use crate::models;
use crate::models::{packets, CUser};
use crate::util::types::FixedLengthArray;
use crate::TEOS;
use tiberius::{Client, Result, Row};
use tokio::net::TcpStream;
use tokio_util::compat::Compat;
use crate::models::packets::CharacterListPacket;

/// The total number of character slots.
const CHARACTER_SLOTS: u8 = 5;

/// Sends the character list.
///
/// # Arguments
/// * `user`    - The user instance.
/// * `client`  - The database client.
pub async fn send_character_list(
    user: &CUser,
    mut client: Client<Compat<TcpStream>>,
) -> anyhow::Result<()> {
    // The user uid
    let user_uid = user.billing_id;

    // Execute the procedure to load the user's characters.
    let mut stream = client
        .query(
            "EXEC PS_GameData.dbo.usp_Read_Chars_R @ServerID = @P1, @UserUID = @P2",
            &[&1, &user_uid],
        )
        .await?;

    // Map the database rows to packets.
    let results = stream.into_first_result().await?;
    let mut characters: Vec<packets::CharacterListPacket> =
        results.iter()
            .map(|r| row_to_character_packet(r))
            .filter(|p| p.is_ok())
            .map(|p| p.unwrap())
            .collect();

    // Apply the equipment items to each character.
    for character in &mut characters {
        // The capacity of the equipment
        let equipment_capacity = character.equipment_type_ids.capacity() as i32;

        // The equipment items for the character.
        let mut stream = client
            .query("EXEC PS_GameData.dbo.usp_Read_Char_Items_Simple_R @CharID = @P1, @Slot = @P2",
                   &[&character.char_id, &equipment_capacity])
            .await?;
        apply_items(character, stream.into_first_result().await?);
    }

    // Loop through the character slots.
    for slot in 0..CHARACTER_SLOTS {
        // If a database packet exists for the slot, send it.
        let db_packet = characters.iter().find(|p| p.slot == slot);
        if let Some(packet) = db_packet {
            user.send(packet);
            continue;
        }

        // Otherwise, send an empty slot.
        let mut packet = packets::CharacterListPacket::new();
        packet.slot = slot;
        user.send(&packet);
    }
    Ok(())
}

/// Converts a database row to a character packet.
///
/// # Arguments
/// * `row`     - The database row representing a character list packet.
fn row_to_character_packet(row: &Row) -> anyhow::Result<packets::CharacterListPacket> {
    let mut packet = packets::CharacterListPacket::new();

    // Populate the packet from the database rows.
    packet.slot = row.get("Slot").unwrap();
    packet.char_id = row.get("CharID").unwrap();
    packet.level = row.get("Level").unwrap();
    packet.race = row.get("Family").unwrap();
    packet.mode = row.get("Grow").unwrap();
    packet.hair = row.get("Hair").unwrap();
    packet.face = row.get("Face").unwrap();
    packet.height = row.get("Size").unwrap();
    packet.class = row.get("Job").unwrap();
    packet.gender = row.get("Sex").unwrap();
    packet.map = row.get("Map").unwrap();
    packet.strength = row.get("Str").unwrap();
    packet.dexterity = row.get("Dex").unwrap();
    packet.reaction = row.get("Rec").unwrap();
    packet.intelligence = row.get("Int").unwrap();
    packet.wisdom = row.get("Wis").unwrap();
    packet.luck = row.get("Luc").unwrap();
    packet.hitpoints = row.get("HP").unwrap();
    packet.stamina = row.get("SP").unwrap();
    packet.mana = row.get("MP").unwrap();
    packet.name = FixedLengthArray::from_str(row.get("CharName").unwrap());
    Ok(packet)
}

/// Applies a character's equipment to their character list packet.
///
/// # Arguments
/// * `packet`  - The outgoing character packet.
/// * `rows`    - The item rows.
fn apply_items(packet: &mut CharacterListPacket, rows: Vec<Row>) {
    rows.iter().for_each(|r| {
        let slot: u8 = r.get("Slot").unwrap();
        let item_type: u8 = r.get("Type").unwrap();
        let type_id: u8 = r.get("TypeID").unwrap();

        packet.equipment_types.set(slot as usize, item_type);
        packet.equipment_type_ids.set(slot as usize, type_id);
    });
}
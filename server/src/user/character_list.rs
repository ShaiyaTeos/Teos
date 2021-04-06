use crate::models;
use crate::models::{packets, CUser};
use crate::util::types::FixedLengthArray;
use crate::TEOS;
use tiberius::{Client, Result, Row};
use tokio::net::TcpStream;
use tokio_util::compat::Compat;

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
    let user_uid = 1; //user.billing_id;

    // Execute the procedure to load the user's characters.
    let mut stream = client
        .query(
            "EXEC PS_GameData.dbo.usp_Read_Chars_R @ServerID = @P1, @UserUID = @P2",
            &[&1, &user_uid],
        )
        .await?;

    // Map the database rows to packets.
    let results = stream.into_first_result().await?;
    let characters: Vec<packets::CharacterListPacket> =
        results.iter().map(|r| row_to_character_packet(r)).collect();

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
/// * `row` - The database row representing a character list packet.
fn row_to_character_packet(row: &Row) -> packets::CharacterListPacket {
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

    packet.name = FixedLengthArray::from_str(row.get("CharName").unwrap());

    packet
}

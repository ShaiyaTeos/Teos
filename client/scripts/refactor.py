# Refactors the code for the ps0198 client.
# @author Cups
# @category Teos.Refactor
from ghidra.program.model.symbol import SourceType

# Helper function to get a Ghidra Address type
def getAddress(offset):
    return currentProgram.getAddressFactory().getDefaultAddressSpace().getAddress(offset)

# Helper function to either name, or create a symbol
def nameSymbol(addr, name):
    var = getSymbolAt(getAddress(addr))
    if var == None:
        createLabel(getAddress(addr), name, False)
    else:
        var.setName(name, SourceType.USER_DEFINED)

runScript("config.py")
runScript("debug.py")
runScript("net.py")
runScript("player.py")
runScript("render.py")
runScript("sah.py")
runScript("skills.py")
runScript("util.py")
runScript("weather.py")
runScript("window.py")
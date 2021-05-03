# Refactors the code for the ps0198 client.
# @author Cups
# @category Teos.Refactor
from ghidra.program.model.symbol import SourceType
from ghidra.app.cmd.function import ApplyFunctionSignatureCmd
from ghidra.program.model.listing import FunctionSignature
from ghidra.program.model.data import FunctionDefinitionDataType, ParameterDefinition, ParameterDefinitionImpl, ByteDataType, BooleanDataType, IntegerDataType, Pointer32DataType, FloatDataType, StructureDataType, VoidDataType

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

# Creates a data type from a string.
def createDataType(name):
    if name == "u8":
        return ByteDataType()
    elif name == "bool":
        return BooleanDataType()
    elif name == "u32":
        return IntegerDataType()
    elif name == "f32":
        return FloatDataType()
    elif name == "string" or name == "ptr":
        return Pointer32DataType()
    elif name == "void":
        return VoidDataType()
    else:
        return StructureDataType(name, 2)

# Healer function to either name or create a function symbol.
def nameFunc(addr, name, return_type, **kwargs):
    var = getSymbolAt(getAddress(addr))
    if var == None:
        createLabel(getAddress(addr), name, False)
    else:
        var.setName(name, SourceType.USER_DEFINED)

    f = FunctionDefinitionDataType(name)
    f.setReturnType(createDataType(return_type))
    
    params = [None] * len(kwargs)
    for i in range(0, len(kwargs)):
        param = list(kwargs)[i]
        type = list(kwargs.values())[i]

        params[i] = ParameterDefinitionImpl(param, createDataType(type), None)
    f.setArguments(params)

    cmd = ApplyFunctionSignatureCmd(getAddress(addr), f, SourceType.USER_DEFINED)
    cmd.applyTo(currentProgram)

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
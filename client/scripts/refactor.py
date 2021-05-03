# Refactors the code for the ps0198 client.
# @author Cups
# @category Teos.Refactor
from ghidra.program.model.symbol import SourceType
from ghidra.app.cmd.function import ApplyFunctionSignatureCmd
from ghidra.program.model.listing import FunctionSignature
from ghidra.program.model.data import FunctionDefinitionDataType, ParameterDefinition, ParameterDefinitionImpl, ByteDataType, BooleanDataType, ShortDataType, IntegerDataType, Pointer32DataType, FloatDataType, StructureDataType, VoidDataType
from ghidra.app.util import NamespaceUtils
from collections import OrderedDict

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
    elif name == "u16":
        return ShortDataType()
    elif name == "u32":
        return IntegerDataType()
    elif name == "f32":
        return FloatDataType()
    elif name == "string" or name == "ptr":
        return Pointer32DataType()
    elif name == "void":
        return VoidDataType()
    else:
        return name

# Helper function to create a class
def createClass(name):
    st = currentProgram.getSymbolTable()
    namespace = st.getNamespace(name, currentProgram.getGlobalNamespace())
    if namespace != None:
        return namespace

    return st.createClass(currentProgram.getGlobalNamespace(), name, SourceType.USER_DEFINED)

# Helper function to either name or create a function symbol, and refactor it's signature.
def nameFunc(addr, name, namespace=None, this=None, return_type="void", args=[]):
    var = getSymbolAt(getAddress(addr))
    if var == None:
        createLabel(getAddress(addr), name, False)
    else:
        var.setName(name, SourceType.USER_DEFINED)

    if namespace != None:
        symbol = getSymbolAt(getAddress(addr))
        symbol.setNamespace(namespace)

    f = FunctionDefinitionDataType(name)
    f.setReturnType(createDataType(return_type))

    params = [None] * len(args)
    if this != None:
        params.append(None)
        params[0] = ParameterDefinitionImpl("this", Pointer32DataType(this), None)

    for i in range(0, len(args)):
        param, type = args[i]

        offset = 0
        if this != None:
            offset = 1
        params[i + offset] = ParameterDefinitionImpl(param, createDataType(type), None)
    f.setArguments(params)

    cmd = ApplyFunctionSignatureCmd(getAddress(addr), f, SourceType.USER_DEFINED, True, False)
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
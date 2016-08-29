#include "fileio.ch"
#include "protheus.ch"

//--------------------------------------------------------------------
/*/{Protheus.doc} Optimized class for string concatenation without AdvPl's
default memory overhead, using only O.S. processes.
@author Marcelo Camargo
@since 14/07/2016
/*/
//--------------------------------------------------------------------
Class StringBuilder
  // Localization of the empty file after being released from the memory
  Data cFileName
  // Pointer to the local virtual file
  Data nPointer
  // Size of the file in bytes
  Data nMalloc

  Method New( cInit ) Constructor
  Method Append( cBuffer )
  Method Build()
  Method Read()
  Method Dispose()
EndClass

//--------------------------------------------------------------------
/*/{Protheus.doc} New
Constructs the buffer, it can receive an initial value

@author Marcelo Camargo
@since 14/07/2016
@param cInit, the initial value of the buffer
@return StringBuilder
/*/
//--------------------------------------------------------------------
Method New( cBuffer ) Class StringBuilder
  Local cUUID := AllTrim( Str( Randomize( 0, 100000 ) ) ) + ;
                 AllTrim( Str( Randomize( 0, 100000 ) ) )
  Self:cFileName := GetTempPath() + cUUID

  // We create a virtual file
  Self:nPointer := FCreate( Self:cFileName )

  If Self:nPointer == -1
    UserException( "StringBuilder: Failed to allocate memory. Error " + AllTrim( Str( FError() ) ) )
    Return Self
  EndIf

  // When there is an initial file, allocate it
  If cBuffer != Nil
    FWrite( Self:nPointer, cBuffer )
    Self:nMalloc := FSeek( Self:nPointer, 0, FS_END )
  Else
    Self:nMalloc := 0
  EndIf

  Return Self

//--------------------------------------------------------------------
/*/{Protheus.doc} Append
Appends a string to the buffer, looking for the final pointer

@author Marcelo Camargo
@since 14/07/2016
@param cBuffer, string to append
@return Nil
/*/
//--------------------------------------------------------------------
Method Append( cBuffer ) Class StringBuilder
  FSeek( Self:nPointer, 0, FS_END )
  FWrite( Self:nPointer, cBuffer )
  Self:nMalloc := FSeek( Self:nPointer, 0, FS_END )
  Return

//--------------------------------------------------------------------
/*/{Protheus.doc} Read
Reads, as string, the content of the physical memory.

@author Marcelo Camargo
@since 14/07/2016
@return String
/*/
//--------------------------------------------------------------------
Method Read() Class StringBuilder
  Local cBigStr := ''
  FSeek( Self:nPointer, 0 )
  FRead( Self:nPointer, cBigStr, Self:nMalloc )
  Return cBigStr

//--------------------------------------------------------------------
/*/{Protheus.doc} Dispose
Clears all the physical and virtual memory content. It must be called when
all operations in the string are finished. It is an internal garbage collector.

@author Marcelo Camargo
@since 14/07/2016
@return Nil
/*/
//--------------------------------------------------------------------
Method Dispose() Class StringBuilder
  Local nMaxPos := FSeek( Self:nPointer, 0, FS_END )

  FSeek( Self:nPointer, 0 )
  FWrite( Self:nPointer, Replicate( Chr( 0 ), nMaxPos ) )
  FClose( Self:nPointer )

  If File( Self:cFileName )
    FErase( Self:cFileName )
  EndIf

  Return


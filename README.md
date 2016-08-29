## AdvPL StringBuilder

This is an implementation of string concatenation for AdvPL based on *virtual pointers* and on an internal research.

Basically, in AdvPL, every string is immutable. When you do `+`, you have a `O(n ^ 2)` complexity, which is **very** expensive. Our implementation reduces it to `O(1)`, preallocating and reading directly from the memory, without any dependency on `+`. In our tests, we've got to run 240 times faster than in the classic model. Its use is recommended only for large string concatenation operation. `+` is faster for small strings.

## Installation

Just copy and compile the file `StringBuilder.prw` under `./src`.

## Interface

```harbour
Class StringBuilder
  Method New( cInit ) Constructor
  Method Append( cBuffer )
  Method Build()
  Method Read()
  Method Dispose()
EndClass
```

## Example

```harbour
Function TestStr
  Local nI
  Local oBuilder := StringBuilder():New( 'optional initializer' )
  oBuilder:Append( '...' )
  
  For nI := 1 To 100000
    oBuilder:Append( AllTrim( Str( nI ) ) )
  Next nI
  
  ConOut( oBuilder:Read() ) // "optional initializer... 123456789101112" and so on...
  oBuilder:Dispose() // Clear garbage from memory. Manual GC
```

## Maintainers

This project is maintained and developed by [NG Informática](http://ngi.com.br) ─ TOTVS Software Partner

<div align="center" style="width: 100%; height: 100px; vertical-align:middle;">
   <div>
      <img src="https://avatars1.githubusercontent.com/u/21263692?v=3&s=200" />
   </div>
   <div>
      <img src="http://www.escriba.com.br/wp-content/uploads/2014/10/totvs.png" width="100" />
   </div>
</div>

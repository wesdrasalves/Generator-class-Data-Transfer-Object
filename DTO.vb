Imports System
Imports System.Collections.Generic
Imports System.Runtime.InteropServices

Public Enum DTOType
    dbInteger
    dbVarchar
    dbBit
    dbChar
    dbDate
    dbCurrency
    dbBigInt
    dbDouble
    dbBoolean
    dbDecimal
    dbNumeric
    dbSmallInt
End Enum

<Serializable()> _
Public Class DTO 
    Implements IDisposable

    Protected disposed As Boolean = False

    'Implement IDisposable.
    Public Overloads Sub Dispose() Implements IDisposable.Dispose
        Dispose(True)
        GC.SuppressFinalize(Me)
    End Sub

    Protected Overridable Overloads Sub Dispose(disposing As Boolean)
        If disposed = False Then
            If disposing Then
                ' Free other state (managed objects).
            End If
            disposed = True
        End If
    End Sub

    Protected Overrides Sub Finalize()
        ' Simply call Dispose(False).
        Dispose(False)
    End Sub

    Public Class ParametersAttribute
        Inherits Attribute

        Private _Type As DTOType
        Public Property Type() As DTOType
            Get
                Return _Type
            End Get
            Set(ByVal value As DTOType)
                _Type = value
            End Set
        End Property

        Private _Length As Integer
        Public Property Length() As Integer
            Get
                Return _Length
            End Get
            Set(ByVal value As Integer)
                _Length = value
            End Set
        End Property

        Private _Chave As Boolean
        Public Property Chave() As Boolean
            Get
                Return _Chave
            End Get
            Set(ByVal value As Boolean)
                _Chave = value
            End Set
        End Property

        Private _ChaveEstrangeira As String
        Public Property ChaveEstrangeira() As String
            Get
                Return _ChaveEstrangeira
            End Get
            Set(ByVal value As String)
                _ChaveEstrangeira = value
            End Set
        End Property
    End Class

    Public Function Clone() As DTO
        Return DirectCast(Me.MemberwiseClone, DTO)
    End Function
End Class

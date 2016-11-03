using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MyArchitecture
{
    
    public enum DTOType{
        dbInteger,
        dbVarchar,
        dbBit,
        dbChar,
        dbDate,
        dbCurrency,
        dbBigInt,
        dbDouble,
        dbBoolean,
        dbDecimal,
        dbNumeric,
        dbSmallInt
    }

    [Serializable()]
    public class DTO : IDisposable
    {
        protected bool disposed = false;

            public void Dispose()   
            {
                this.Dispose(true);
                GC.SuppressFinalize(this);
            }

        protected void Dispose(bool disposing) 
        {
            if(!disposed)
            {
                if(disposing)
                {
                    // Free other state (managed objects).
                }
                disposed = true;
            }
        }

        protected  void finalize()
        {
            Dispose(false);
        }

        public DTO Clone() 
        {
            return (DTO)this.MemberwiseClone();
        }

        public class ParametersAttribute : Attribute
        {
            private DTOType _type;
            private int _length;
            private bool _key;
            private string _foreignKey; 

            public DTOType Type
            {
                get{ return _type; }
                set{ _type = value; }
            }

            public int Length 
            {
                get{ return _length; }
                set{_length = value; }
            }
            public bool Key
            {    
                get{ return _key;}
                set { _key = value; }
            }

            public string ForeignKey
            {
                get{ return _foreignKey;}
                set {_foreignKey = value; }
            }
        }
    }
}

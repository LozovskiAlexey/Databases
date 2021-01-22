using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;
using System.Text;
using Microsoft.SqlServer.Server;


[Serializable]
[Microsoft.SqlServer.Server.SqlUserDefinedAggregate(Format.UserDefined,
    IsInvariantToNulls = true,
    IsInvariantToDuplicates = false,
    IsInvariantToOrder = false,
    MaxByteSize = 8000)]
public class Combine : IBinarySerialize
{
    // Тут храним считанные строки столбца
    public StringBuilder str_union;

    // инициализируем поле куда будет читать 
    public void Init()
    {
        this.str_union = new StringBuilder();
    }

    // заполняем нашу строку значением, если оно не пустое
    public void Accumulate(SqlString value)
    {
        if (value.IsNull)
        {
            return;
        }
        this.str_union.Append(value.Value).Append(',');
    }

    // Добавляем к существующей группе новую
    public void Merge(Combine Group)
    {
        this.str_union.Append(Group.str_union);
    }

    
    public SqlString Terminate()
    {
        string output = string.Empty; // строка нулевой длины

        // если данные не пустые - преобразуем их в строку и преобразуем в sql-тип
        if (this.str_union != null && this.str_union.Length > 0)
            output = this.str_union.ToString(0, this.str_union.Length - 1);
        return new SqlString(output);
    }

    // вспомогательные методы чтения-записи данных 
    public void Read(BinaryReader r)
    {
        str_union = new StringBuilder(r.ReadString());
    }

    public void Write(BinaryWriter w)
    {
        w.Write(this.str_union.ToString());
    }
}
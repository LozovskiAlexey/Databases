using System;
using System.Data;
using System.Collections;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public class Record
{
    public SqlInt32 Id;
    public SqlString Name;

    public Record(SqlInt32 _Id, SqlString _Name) 
    {
        Id = _Id;
        Name = _Name;
    }
}

public partial class TableFunction
{
    [SqlFunction(
       DataAccess = DataAccessKind.Read,
       FillRowMethodName = "FillRow",
       TableDefinition = "ActorId INT,ActorName NVARCHAR(50)")]

    public static IEnumerable getActors(SqlString movieName)
    {
        // Гениальный запрос
        string queryString = "SELECT dbo.A.Ano, Aname FROM dbo.A JOIN dbo.A_M on dbo.A.Ano=dbo.A_M.Ano JOIN dbo.M on dbo.A_M.Mno=M.Mno WHERE dbo.M.Mname = '" + (String)movieName + "'";

        // Гениальный массив для не менее гениального результата
        // гениального запроса 
        ArrayList result = new ArrayList();

    
        using (SqlConnection connection = new SqlConnection("context connection=true"))
        {
            SqlCommand cmd = new SqlCommand(queryString, connection);
            connection.Open();

            // выполнит запрос, получит таблицу, прочитает построчно эту таблицу 
            SqlDataReader reader = cmd.ExecuteReader();

            // читаем таблицу, пока читается
            while (reader.Read()) 
            {
                // вытащили из считанной строки данные 
                SqlInt32 tmp_id = reader.GetSqlInt32(0);
                SqlString tmp_name = reader.GetSqlString(1);

                // обернули их в презентабельный вид
                Record tmp = new Record(tmp_id, tmp_name);

                // добавили это чудо к другим красавцам
                result.Add(tmp);
            }

            // таблицу считал - пора на покой
            reader.Close();
        }
        return result;
    }


    public static void FillRow(Object obj, out SqlInt32 id, out SqlString Name) 
    {
        Record tmp = (Record)obj;
        id = tmp.Id;
        Name = tmp.Name;
    }
}


using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class StoredProcedures
{
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void InsertUnique(SqlString Name, SqlInt32 Rate)
    {
        using (SqlConnection connection = new SqlConnection("context connection=true"))
        {
            string queryString = "IF NOT EXISTS (SELECT MovieName FROM dbo.tmp_table WHERE MovieName = @Name) " +
                                    "BEGIN " +
                                        "INSERT INTO dbo.tmp_table VALUES (@Name, @Rate) " +
                                    "END";

            connection.Open();
            SqlCommand cmd = new SqlCommand(queryString, connection);

            cmd.Parameters.Add("@Name", Name);
            cmd.Parameters.Add("@Rate", Rate);

            SqlContext.Pipe.ExecuteAndSend(cmd);
        }
    }
}

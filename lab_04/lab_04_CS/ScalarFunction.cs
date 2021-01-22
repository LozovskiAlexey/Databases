using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

// Скалярная функция, которая вернет количество фильмов, выпущенных заданной
// пользователем страной
public partial class ScalarFunction
{
    [SqlFunction(DataAccess = DataAccessKind.Read)]

    public static int sqlCountMovies(SqlString country)
    {
        using (SqlConnection conn = new SqlConnection("context connection=true"))
        {
            conn.Open();

            SqlCommand cmd = new SqlCommand(
                "SELECT COUNT(Mno) AS 'Movie Amount' FROM M " +
                "WHERE Mctry = '" + (string)country + "'", conn);

            return (int)cmd.ExecuteScalar();
        }
    }
}



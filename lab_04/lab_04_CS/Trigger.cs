using System;
using System.Data;
using System.Data.SqlClient;
using Microsoft.SqlServer.Server;

public partial class Triggers
{
    public static void OnDelete()
    {
        string ActorName;
        int ActorId;

        SqlCommand command;
        SqlPipe pipe = SqlContext.Pipe;
        SqlDataReader reader;

        SqlTriggerContext triggContext = SqlContext.TriggerContext;
        switch (triggContext.TriggerAction)
        {
            case TriggerAction.Delete:

                using (SqlConnection connection = new SqlConnection(@"context connection=true"))
                {
                    connection.Open();

                    command = new SqlCommand(@"SELECT * FROM DELETED;", connection);
                    reader = command.ExecuteReader();

                    reader.Read();
                    ActorId = (int)reader[0];
                    ActorName = (string)reader[1];               
                    reader.Close();

                    string querystring = "INSERT INTO dbo.history(deletedId, msg) " +
                                         "VALUES (@Ano, 'Actor ' + @AName + ' was deleted.')";
                    command = new SqlCommand(querystring, connection);

                    command.Parameters.Add("@Ano", ActorId);
                    command.Parameters.Add("@Aname", ActorName);

                    SqlContext.Pipe.ExecuteAndSend(command);
                }

                break;

            default:
                break;
        }
    }
}


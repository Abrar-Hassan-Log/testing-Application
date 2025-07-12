using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Net.NetworkInformation;
using System.Web.Services;

namespace testing_Application
{
    public class User
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string Address { get; set; }

    }
    public partial class Contact : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
           
        }

        [WebMethod]
        public static string SaveUser(string fullName, string email, string address)
        {
            string connStr = "Data Source=ABRAR-IT-PC; Initial Catalog=Employee; Integrated Security=True; Encrypt=False; TrustServerCertificate=True";



            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "INSERT INTO Users (Name, Email, Address) VALUES (@Name, @Email, @Address)";
                SqlCommand cmd = new SqlCommand(query, conn);

                cmd.Parameters.AddWithValue("@Name", fullName);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Address", address);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    return "User saved successfully!";
                }
                catch (Exception ex)
                {
                    return "Error: " + ex.Message;
                }
            }
        }

        [WebMethod]
        public static List<User> GetUserRecord()
        {
            List<User> users = new List<User>();
            string connStr = "Data Source=ABRAR-IT-PC; Initial Catalog=Employee; Integrated Security=True; Encrypt=False; TrustServerCertificate=True";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT Id, Name, Email, Address FROM Users"; // include Id column
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    users.Add(new User
                    {
                        Id = reader["Id"].ToString(),
                        Name = reader["Name"].ToString(),
                        Email = reader["Email"].ToString(),
                        Address = reader["Address"].ToString()
                    });
                }
            }

            return users;
        }
        [WebMethod]
        public static User GetbyUserId(string id)
        {
            try
            {
                User user = null;
                string connStr = "Data Source=ABRAR-IT-PC; Initial Catalog=Employee; Integrated Security=True; Encrypt=False; TrustServerCertificate=True"; // your connection string

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "SELECT Id, Name, Email, Address FROM Users WHERE Id = @Id";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Id", id);
                    conn.Open();

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        user = new User
                        {
                            Id = reader["Id"].ToString(),
                            Name = reader["Name"].ToString(),
                            Email = reader["Email"].ToString(),
                            Address = reader["Address"].ToString()
                        };
                    }
                }

                return user;
            }
            catch (Exception ex)
            {
                // Log ex.Message somewhere, e.g. Debug, Event Log, etc.
                throw new Exception("Error in GetbyUserId: " + ex.Message);
            }
        }
        [WebMethod]
        public static string UpdateUser(string id, string fullName, string email, string address)
        {
            string connStr = "Data Source=ABRAR-IT-PC; Initial Catalog=Employee; Integrated Security=True; Encrypt=False; TrustServerCertificate=True";



            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "UPDATE Users SET Name = @Name, Email = @Email, Address = @Address WHERE Id = @Id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Id", id);
                cmd.Parameters.AddWithValue("@Name", fullName);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Address", address);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    return "User saved successfully!";
                }
                catch (Exception ex)
                {
                    return "Error: " + ex.Message;
                }
            }
        }
        [WebMethod]
        public static string DeleteRecord(string id)
        {
            string connStr = "Data Source=ABRAR-IT-PC; Initial Catalog=Employee; Integrated Security=True; Encrypt=False; TrustServerCertificate=True";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "DELETE FROM Users WHERE Id = @Id";
                SqlCommand cmd = new SqlCommand(query, conn);

                // ✅ Add the missing parameter
                cmd.Parameters.AddWithValue("@Id", id);

                try
                {
                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                        return "User deleted successfully!";
                    else
                        return "No user found with the specified ID.";
                }
                catch (Exception ex)
                {
                    return "Error: " + ex.Message;
                }
            }
        }


    }
}

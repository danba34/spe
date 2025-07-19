using MySql.Data.MySqlClient;
using System.Configuration;
using System.Data;

namespace Speedan.Repository
{
    public class BaseRepository
    {
        protected readonly string _connectionString;

        public BaseRepository()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["MySqlConnection"].ConnectionString;
        }

        public MySqlConnection GetConnection()  // Cambiar a public para acceso desde code-behind
        {
            return new MySqlConnection(_connectionString);
        }
    }
}
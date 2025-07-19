using MySql.Data.MySqlClient;
using Speedan.Models;
using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;

namespace Speedan.Repository
{
    public class UsuarioRepository : BaseRepository
    {
        public Usuario ValidarUsuario(string nombreUsuario, string contrasena)
        {
            string hashedPassword = HashPassword(contrasena);
            using (var connection = GetConnection())
            {
                connection.Open();
                string query = "SELECT IdUsuario, NombreUsuario, Rol FROM Usuario WHERE NombreUsuario = @usuario AND Contrasena = @contrasena";
                using (var command = new MySqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@usuario", nombreUsuario);
                    command.Parameters.AddWithValue("@contrasena", hashedPassword);
                    using (var reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            return new Usuario
                            {
                                IdUsuario = reader.GetInt32("IdUsuario"),
                                NombreUsuario = reader.GetString("NombreUsuario"),
                                Rol = reader.GetString("Rol")
                            };
                        }
                    }
                }
            }
            return null;
        }

        public List<Usuario> ObtenerTodos()
        {
            var usuarios = new List<Usuario>();
            using (var connection = GetConnection())
            {
                connection.Open();
                string query = "SELECT IdUsuario, NombreUsuario, Rol FROM Usuario ORDER BY NombreUsuario";
                using (var command = new MySqlCommand(query, connection))
                using (var reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        usuarios.Add(new Usuario
                        {
                            IdUsuario = reader.GetInt32("IdUsuario"),
                            NombreUsuario = reader.GetString("NombreUsuario"),
                            Rol = reader.GetString("Rol")
                        });
                    }
                }
            }
            return usuarios;
        }

        public Usuario ObtenerPorId(int id)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                string query = "SELECT IdUsuario, NombreUsuario, Rol FROM Usuario WHERE IdUsuario = @id";
                using (var command = new MySqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@id", id);
                    using (var reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            return new Usuario
                            {
                                IdUsuario = reader.GetInt32("IdUsuario"),
                                NombreUsuario = reader.GetString("NombreUsuario"),
                                Rol = reader.GetString("Rol")
                            };
                        }
                    }
                }
            }
            return null;
        }

        public bool Insertar(Usuario usuario)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                string query = "INSERT INTO Usuario (NombreUsuario, Contrasena, Rol) VALUES (@nombre, @contrasena, @rol)";
                using (var command = new MySqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@nombre", usuario.NombreUsuario);
                    command.Parameters.AddWithValue("@contrasena", HashPassword(usuario.Contrasena));
                    command.Parameters.AddWithValue("@rol", usuario.Rol);
                    return command.ExecuteNonQuery() > 0;
                }
            }
        }

        public bool Actualizar(Usuario usuario)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                string query = string.IsNullOrEmpty(usuario.Contrasena) ?
                    "UPDATE Usuario SET NombreUsuario = @nombre, Rol = @rol WHERE IdUsuario = @id" :
                    "UPDATE Usuario SET NombreUsuario = @nombre, Contrasena = @contrasena, Rol = @rol WHERE IdUsuario = @id";

                using (var command = new MySqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@id", usuario.IdUsuario);
                    command.Parameters.AddWithValue("@nombre", usuario.NombreUsuario);
                    command.Parameters.AddWithValue("@rol", usuario.Rol);
                    if (!string.IsNullOrEmpty(usuario.Contrasena))
                        command.Parameters.AddWithValue("@contrasena", HashPassword(usuario.Contrasena));
                    return command.ExecuteNonQuery() > 0;
                }
            }
        }

        public bool Eliminar(int id)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                string query = "DELETE FROM Usuario WHERE IdUsuario = @id";
                using (var command = new MySqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@id", id);
                    return command.ExecuteNonQuery() > 0;
                }
            }
        }

        private string HashPassword(string password)
        {
            using (var sha256 = SHA256.Create())
            {
                byte[] hashedBytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                return BitConverter.ToString(hashedBytes).Replace("-", "").ToLower();
            }
        }
    }
}
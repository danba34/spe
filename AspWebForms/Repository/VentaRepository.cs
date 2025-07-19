using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using Speedan.Models;

namespace Speedan.Repository
{
    public class VentaRepository : BaseRepository
    {
        public List<Venta> ObtenerVentas()
        {
            var ventas = new List<Venta>();
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = @"SELECT v.IdVenta, v.IdUsuario, v.FechaVenta, v.Total, u.NombreUsuario 
                             FROM Venta v 
                             JOIN Usuario u ON v.IdUsuario = u.IdUsuario 
                             ORDER BY v.FechaVenta DESC";

                using (var cmd = new MySqlCommand(query, connection))
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        ventas.Add(new Venta
                        {
                            IdVenta = reader.GetInt32(reader.GetOrdinal("IdVenta")),
                            IdUsuario = reader.GetInt32(reader.GetOrdinal("IdUsuario")),
                            FechaVenta = reader.GetDateTime(reader.GetOrdinal("FechaVenta")),
                            Total = reader.GetDecimal(reader.GetOrdinal("Total")),
                            NombreUsuario = reader.GetString(reader.GetOrdinal("NombreUsuario"))
                        });
                    }
                }
            }
            return ventas;
        }

        public List<Producto> ObtenerProductos()
        {
            var productos = new List<Producto>();
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = "SELECT IdProducto, Modelo, Talla, Color, Precio, Stock FROM Producto WHERE Stock > 0";

                using (var cmd = new MySqlCommand(query, connection))
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        productos.Add(new Producto
                        {
                            IdProducto = reader.GetInt32(reader.GetOrdinal("IdProducto")),
                            Modelo = reader.GetString(reader.GetOrdinal("Modelo")),
                            Talla = reader.GetDecimal(reader.GetOrdinal("Talla")),
                            Color = reader.GetString(reader.GetOrdinal("Color")),
                            Precio = reader.GetDecimal(reader.GetOrdinal("Precio")),
                            Stock = reader.GetInt32(reader.GetOrdinal("Stock"))
                        });
                    }
                }
            }
            return productos;
        }

        public bool CrearVenta(int idUsuario, int idProducto, int cantidad)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        // Obtener precio del producto
                        var queryPrecio = "SELECT Precio FROM Producto WHERE IdProducto = @IdProducto";
                        decimal precio = 0;
                        using (var cmd = new MySqlCommand(queryPrecio, connection, transaction))
                        {
                            cmd.Parameters.AddWithValue("@IdProducto", idProducto);
                            precio = (decimal)cmd.ExecuteScalar();
                        }

                        var total = precio * cantidad;

                        // Insertar venta
                        var insertVenta = "INSERT INTO Venta (IdUsuario, Total) VALUES (@IdUsuario, @Total)";
                        int idVenta = 0;
                        using (var cmd = new MySqlCommand(insertVenta, connection, transaction))
                        {
                            cmd.Parameters.AddWithValue("@IdUsuario", idUsuario);
                            cmd.Parameters.AddWithValue("@Total", total);
                            cmd.ExecuteNonQuery();
                            idVenta = (int)cmd.LastInsertedId;
                        }

                        // Insertar detalle
                        var insertDetalle = @"INSERT INTO DetalleVenta (IdVenta, IdProducto, Cantidad, PrecioUnitario, Subtotal) 
                                            VALUES (@IdVenta, @IdProducto, @Cantidad, @PrecioUnitario, @Subtotal)";
                        using (var cmd = new MySqlCommand(insertDetalle, connection, transaction))
                        {
                            cmd.Parameters.AddWithValue("@IdVenta", idVenta);
                            cmd.Parameters.AddWithValue("@IdProducto", idProducto);
                            cmd.Parameters.AddWithValue("@Cantidad", cantidad);
                            cmd.Parameters.AddWithValue("@PrecioUnitario", precio);
                            cmd.Parameters.AddWithValue("@Subtotal", total);
                            cmd.ExecuteNonQuery();
                        }

                        // Actualizar stock
                        var updateStock = "UPDATE Producto SET Stock = Stock - @Cantidad WHERE IdProducto = @IdProducto";
                        using (var cmd = new MySqlCommand(updateStock, connection, transaction))
                        {
                            cmd.Parameters.AddWithValue("@Cantidad", cantidad);
                            cmd.Parameters.AddWithValue("@IdProducto", idProducto);
                            cmd.ExecuteNonQuery();
                        }

                        transaction.Commit();
                        return true;
                    }
                    catch
                    {
                        transaction.Rollback();
                        return false;
                    }
                }
            }
        }

        public Venta ObtenerVentaPorId(int idVenta)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = @"SELECT v.IdVenta, v.IdUsuario, v.FechaVenta, v.Total, u.NombreUsuario,
                             d.IdProducto, d.Cantidad, p.Modelo, p.Talla, p.Color
                             FROM Venta v 
                             JOIN Usuario u ON v.IdUsuario = u.IdUsuario
                             JOIN DetalleVenta d ON v.IdVenta = d.IdVenta
                             JOIN Producto p ON d.IdProducto = p.IdProducto
                             WHERE v.IdVenta = @IdVenta";

                using (var cmd = new MySqlCommand(query, connection))
                {
                    cmd.Parameters.AddWithValue("@IdVenta", idVenta);
                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            return new Venta
                            {
                                IdVenta = reader.GetInt32(reader.GetOrdinal("IdVenta")),
                                IdUsuario = reader.GetInt32(reader.GetOrdinal("IdUsuario")),
                                FechaVenta = reader.GetDateTime(reader.GetOrdinal("FechaVenta")),
                                Total = reader.GetDecimal(reader.GetOrdinal("Total")),
                                NombreUsuario = reader.GetString(reader.GetOrdinal("NombreUsuario"))
                            };
                        }
                    }
                }
            }
            return null;
        }

        public bool EditarVenta(int idVenta, int nuevaCantidad)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        // Obtener datos actuales
                        var queryActual = @"SELECT d.IdProducto, d.Cantidad, p.Precio 
                                          FROM DetalleVenta d 
                                          JOIN Producto p ON d.IdProducto = p.IdProducto 
                                          WHERE d.IdVenta = @IdVenta";

                        int idProducto = 0;
                        int cantidadActual = 0;
                        decimal precio = 0;

                        using (var cmd = new MySqlCommand(queryActual, connection, transaction))
                        {
                            cmd.Parameters.AddWithValue("@IdVenta", idVenta);
                            using (var reader = cmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    idProducto = reader.GetInt32(reader.GetOrdinal("IdProducto"));
                                    cantidadActual = reader.GetInt32(reader.GetOrdinal("Cantidad"));
                                    precio = reader.GetDecimal(reader.GetOrdinal("Precio"));
                                }
                            }
                        }

                        // Calcular diferencia para ajustar stock
                        int diferencia = nuevaCantidad - cantidadActual;

                        // Actualizar stock
                        var updateStock = "UPDATE Producto SET Stock = Stock - @Diferencia WHERE IdProducto = @IdProducto";
                        using (var cmd = new MySqlCommand(updateStock, connection, transaction))
                        {
                            cmd.Parameters.AddWithValue("@Diferencia", diferencia);
                            cmd.Parameters.AddWithValue("@IdProducto", idProducto);
                            cmd.ExecuteNonQuery();
                        }

                        // Actualizar detalle de venta
                        var nuevoSubtotal = precio * nuevaCantidad;
                        var updateDetalle = @"UPDATE DetalleVenta SET Cantidad = @NuevaCantidad, Subtotal = @NuevoSubtotal 
                                            WHERE IdVenta = @IdVenta";
                        using (var cmd = new MySqlCommand(updateDetalle, connection, transaction))
                        {
                            cmd.Parameters.AddWithValue("@NuevaCantidad", nuevaCantidad);
                            cmd.Parameters.AddWithValue("@NuevoSubtotal", nuevoSubtotal);
                            cmd.Parameters.AddWithValue("@IdVenta", idVenta);
                            cmd.ExecuteNonQuery();
                        }

                        // Actualizar total de venta
                        var updateVenta = "UPDATE Venta SET Total = @NuevoTotal WHERE IdVenta = @IdVenta";
                        using (var cmd = new MySqlCommand(updateVenta, connection, transaction))
                        {
                            cmd.Parameters.AddWithValue("@NuevoTotal", nuevoSubtotal);
                            cmd.Parameters.AddWithValue("@IdVenta", idVenta);
                            cmd.ExecuteNonQuery();
                        }

                        transaction.Commit();
                        return true;
                    }
                    catch
                    {
                        transaction.Rollback();
                        return false;
                    }
                }
            }
        }

        public bool EliminarVenta(int idVenta)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        // Restaurar stock
                        var queryDetalle = @"SELECT IdProducto, Cantidad FROM DetalleVenta WHERE IdVenta = @IdVenta";
                        using (var cmd = new MySqlCommand(queryDetalle, connection, transaction))
                        {
                            cmd.Parameters.AddWithValue("@IdVenta", idVenta);
                            using (var reader = cmd.ExecuteReader())
                            {
                                var detalles = new List<(int IdProducto, int Cantidad)>();
                                while (reader.Read())
                                {
                                    detalles.Add((reader.GetInt32(0), reader.GetInt32(1)));
                                }
                                reader.Close();

                                foreach (var detalle in detalles)
                                {
                                    var updateStock = "UPDATE Producto SET Stock = Stock + @Cantidad WHERE IdProducto = @IdProducto";
                                    using (var updateCmd = new MySqlCommand(updateStock, connection, transaction))
                                    {
                                        updateCmd.Parameters.AddWithValue("@Cantidad", detalle.Cantidad);
                                        updateCmd.Parameters.AddWithValue("@IdProducto", detalle.IdProducto);
                                        updateCmd.ExecuteNonQuery();
                                    }
                                }
                            }
                        }

                        // Eliminar detalles
                        var deleteDetalle = "DELETE FROM DetalleVenta WHERE IdVenta = @IdVenta";
                        using (var cmd = new MySqlCommand(deleteDetalle, connection, transaction))
                        {
                            cmd.Parameters.AddWithValue("@IdVenta", idVenta);
                            cmd.ExecuteNonQuery();
                        }

                        // Eliminar venta
                        var deleteVenta = "DELETE FROM Venta WHERE IdVenta = @IdVenta";
                        using (var cmd = new MySqlCommand(deleteVenta, connection, transaction))
                        {
                            cmd.Parameters.AddWithValue("@IdVenta", idVenta);
                            cmd.ExecuteNonQuery();
                        }

                        transaction.Commit();
                        return true;
                    }
                    catch
                    {
                        transaction.Rollback();
                        return false;
                    }
                }
            }
        }
    }
}
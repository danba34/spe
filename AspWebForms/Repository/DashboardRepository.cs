using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.Data;

namespace Speedan.Repository
{
    public class DashboardRepository : BaseRepository
    {
        public DataTable ObtenerResumenVentas()
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                string query = @"
                    SELECT 
                        IdVenta as 'ID Venta',
                        Vendedor,
                        DATE_FORMAT(FechaVenta, '%d/%m/%Y %H:%i') as 'Fecha',
                        CONCAT('$', FORMAT(Total, 2)) as 'Total',
                        ProductosVendidos as 'Productos'
                    FROM VistaVentasResumen 
                    ORDER BY FechaVenta DESC";

                using (var command = new MySqlCommand(query, connection))
                using (var adapter = new MySqlDataAdapter(command))
                {
                    var dataTable = new DataTable();
                    adapter.Fill(dataTable);
                    return dataTable;
                }
            }
        }

        public DataTable ObtenerProductosBajoStock()
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                string query = @"
                    SELECT 
                        Modelo,
                        Color,
                        Talla,
                        Stock,
                        CASE 
                            WHEN Stock = 0 THEN 'Sin Stock'
                            WHEN Stock < 5 THEN 'Crítico'
                            ELSE 'Bajo'
                        END as 'Estado'
                    FROM VistaProductosBajoStock 
                    ORDER BY Stock ASC";

                using (var command = new MySqlCommand(query, connection))
                using (var adapter = new MySqlDataAdapter(command))
                {
                    var dataTable = new DataTable();
                    adapter.Fill(dataTable);
                    return dataTable;
                }
            }
        }

        public DataTable ObtenerInventarioCompleto()
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                string query = @"
                    SELECT 
                        p.IdProducto as 'ID',
                        p.Modelo,
                        p.Color,
                        p.Talla,
                        CONCAT('$', FORMAT(p.Precio, 2)) as 'Precio',
                        p.Stock,
                        CONCAT('$', FORMAT(p.Precio * p.Stock, 2)) as 'Valor Total',
                        CASE 
                            WHEN p.Stock = 0 THEN 'Sin Stock'
                            WHEN p.Stock < 10 THEN 'Bajo Stock'
                            ELSE 'Disponible'
                        END as 'Estado'
                    FROM Producto p
                    ORDER BY p.Modelo, p.Color";

                using (var command = new MySqlCommand(query, connection))
                using (var adapter = new MySqlDataAdapter(command))
                {
                    var dataTable = new DataTable();
                    adapter.Fill(dataTable);
                    return dataTable;
                }
            }
        }

        public Dictionary<string, object> ObtenerEstadisticas()
        {
            var estadisticas = new Dictionary<string, object>();

            using (var connection = GetConnection())
            {
                connection.Open();

                // Total de productos
                string query = "SELECT COUNT(*) FROM Producto";
                using (var command = new MySqlCommand(query, connection))
                {
                    estadisticas["TotalProductos"] = command.ExecuteScalar();
                }

                // Total de ventas
                query = "SELECT COUNT(*) FROM Venta";
                using (var command = new MySqlCommand(query, connection))
                {
                    estadisticas["TotalVentas"] = command.ExecuteScalar();
                }

                // Productos bajo stock
                query = "SELECT COUNT(*) FROM VistaProductosBajoStock";
                using (var command = new MySqlCommand(query, connection))
                {
                    estadisticas["ProductosBajoStock"] = command.ExecuteScalar();
                }

                // Total ingresos
                query = "SELECT IFNULL(SUM(Total), 0) FROM Venta";
                using (var command = new MySqlCommand(query, connection))
                {
                    estadisticas["TotalIngresos"] = command.ExecuteScalar();
                }
            }

            return estadisticas;
        }
    }
}
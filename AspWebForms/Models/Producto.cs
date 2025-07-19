using System;
using Dapper.Contrib.Extensions;

namespace Speedan.Models
{
    [Table("Producto")]
    public class Producto
    {
        [Key]
        public int IdProducto { get; set; }
        public string Modelo { get; set; }
        public decimal Talla { get; set; }
        public string Color { get; set; }
        public decimal Precio { get; set; }
        public int Stock { get; set; }
    }
}
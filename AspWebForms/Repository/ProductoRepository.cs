using Dapper.Contrib.Extensions;
using Speedan.Models;
using System.Collections.Generic;

namespace Speedan.Repository
{
    public class ProductoRepository : BaseRepository
    {
        public IEnumerable<Producto> ObtenerTodos() =>
            GetConnection().GetAll<Producto>();

        public void Insertar(Producto producto) =>
            GetConnection().Insert(producto);

        public void Actualizar(Producto producto) =>
            GetConnection().Update(producto);

        public void Eliminar(int id) =>
            GetConnection().Delete(new Producto { IdProducto = id });

        public Producto ObtenerPorId(int id) =>
            GetConnection().Get<Producto>(id);
    }
}
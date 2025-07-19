using System;

public class Venta
{
    public int IdVenta { get; set; }
    public int IdUsuario { get; set; }
    public DateTime FechaVenta { get; set; }
    public decimal Total { get; set; }
    public string NombreUsuario { get; set; }
}
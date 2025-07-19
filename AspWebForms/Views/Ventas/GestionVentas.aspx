<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GestionVentas.aspx.cs" Inherits="Speedan.Views.Ventas.GestionVentas" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Speedan - Gestión de Ventas</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; }
        .header { background-color: #007bff; color: white; padding: 15px; display: flex; justify-content: space-between; align-items: center; }
        .container { max-width: 1400px; margin: 20px auto; padding: 0 20px; }
        .card { background: white; border-radius: 8px; padding: 20px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        
        /* Grid */
        .grid { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .grid th, .grid td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        .grid th { background-color: #f8f9fa; font-weight: bold; }
        .grid tr:hover { background-color: #f5f5f5; }
        
        /* Buttons */
        .btn { padding: 8px 15px; margin: 2px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block; }
        .btn-primary { background-color: #007bff; color: white; }
        .btn-success { background-color: #28a745; color: white; }
        .btn-danger { background-color: #dc3545; color: white; }
        .btn-secondary { background-color: #6c757d; color: white; }
        .btn-info { background-color: #17a2b8; color: white; }
        .btn:hover { opacity: 0.8; }
        
        /* Form */
        .form-row { display: flex; gap: 15px; margin-bottom: 15px; align-items: center; }
        .form-row label { min-width: 80px; font-weight: bold; }
        .form-row select, .form-row input { padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
        
        /* Messages */
        .mensaje { padding: 10px; margin: 10px 0; border-radius: 4px; }
        .mensaje.success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .mensaje.error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        
        /* Modal */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); }
        .modal-content { background-color: #fefefe; margin: 15% auto; padding: 20px; border-radius: 8px; width: 400px; }
        .close { color: #aaa; float: right; font-size: 28px; font-weight: bold; cursor: pointer; }
        .close:hover { color: black; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div class="header">
        <h1>Gestión de Ventas</h1>
        <div>
            <a href="../../Dashboard.aspx" class="btn btn-secondary">Volver al Dashboard</a>
        </div>
    </div>

        <div class="container">
            <asp:Label ID="lblMensaje" runat="server" CssClass="mensaje" Visible="false"></asp:Label>
            
            <!-- Panel para Nueva Venta -->
            <div class="card">
                <h2>Nueva Venta</h2>
                <div class="form-row">
                    <label>Usuario:</label>
                    <asp:DropDownList ID="ddlUsuario" runat="server">
                        <asp:ListItem Value="2" Text="Vendedor1"></asp:ListItem>
                        <asp:ListItem Value="3" Text="Vendedor2"></asp:ListItem>
                    </asp:DropDownList>
                    
                    <label>Producto:</label>
                    <asp:DropDownList ID="ddlProducto" runat="server" DataTextField="Descripcion" DataValueField="IdProducto" Width="300px">
                    </asp:DropDownList>
                    
                    <label>Cantidad:</label>
                    <asp:TextBox ID="txtCantidad" runat="server" TextMode="Number" Text="1" Width="60px"></asp:TextBox>
                    
                    <asp:Button ID="btnCrearVenta" runat="server" Text="Crear Venta" CssClass="btn btn-primary" OnClick="btnCrearVenta_Click" />
                </div>
            </div>
            
            <!-- Grid de Ventas -->
            <div class="card">
                <h2>Ventas Registradas</h2>
                <asp:GridView ID="gvVentas" runat="server" AutoGenerateColumns="false" CssClass="grid" 
                    OnRowCommand="gvVentas_RowCommand" OnRowEditing="gvVentas_RowEditing" 
                    OnRowCancelingEdit="gvVentas_RowCancelingEdit" OnRowUpdating="gvVentas_RowUpdating"
                    DataKeyNames="IdVenta">
                    <Columns>
                        <asp:BoundField DataField="IdVenta" HeaderText="ID" ReadOnly="true" />
                        <asp:BoundField DataField="NombreUsuario" HeaderText="Vendedor" ReadOnly="true" />
                        <asp:BoundField DataField="FechaVenta" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy HH:mm}" ReadOnly="true" />
                        <asp:TemplateField HeaderText="Cantidad">
                            <ItemTemplate>
                                <asp:Label ID="lblCantidad" runat="server" Text='<%# Eval("Cantidad") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtEditCantidad" runat="server" Text='<%# Bind("Cantidad") %>' TextMode="Number" Width="60px"></asp:TextBox>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Total" HeaderText="Total" DataFormatString="{0:C}" ReadOnly="true" />
                        <asp:CommandField ShowEditButton="true" EditText="Editar" UpdateText="Guardar" CancelText="Cancelar" 
                            ButtonType="Button" ControlStyle-CssClass="btn btn-info" />
                        <asp:TemplateField HeaderText="Eliminar">
                            <ItemTemplate>
                                <asp:Button ID="btnEliminar" runat="server" Text="Eliminar" CssClass="btn btn-danger" 
                                    CommandName="Eliminar" CommandArgument='<%# Eval("IdVenta") %>' 
                                    OnClientClick="return confirm('¿Está seguro de eliminar esta venta?');" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
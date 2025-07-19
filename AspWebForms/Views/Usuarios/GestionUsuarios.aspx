<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GestionUsuarios.aspx.cs" Inherits="Speedan.Views.Usuarios.GestionUsuarios" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Gestión de Usuarios - Speedan</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; }
        .header { background-color: #007bff; color: white; padding: 15px; display: flex; justify-content: space-between; align-items: center; }
        .container { max-width: 1400px; margin: 20px auto; padding: 0 20px; }
        .card { background: white; border-radius: 8px; padding: 20px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input, .form-group select { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
        
        .btn { padding: 8px 16px; margin: 3px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block; }
        .btn-primary { background-color: #007bff; color: white; }
        .btn-success { background-color: #28a745; color: white; }
        .btn-danger { background-color: #dc3545; color: white; }
        .btn-secondary { background-color: #6c757d; color: white; }
        .btn:hover { opacity: 0.8; }
        
        .grid { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .grid th, .grid td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        .grid th { background-color: #f8f9fa; font-weight: bold; }
        .grid tr:hover { background-color: #f5f5f5; }
        
        .alert { padding: 15px; margin: 10px 0; border-radius: 4px; }
        .alert-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-danger { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        
        .form-inline { display: flex; gap: 10px; align-items: end; margin-bottom: 20px; }
        .form-inline .form-group { margin-bottom: 0; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <h1>Gestión de Usuarios</h1>
            <div>
                <a href="../../Dashboard.aspx" class="btn btn-secondary">Volver al Dashboard</a>
            </div>

            <div>
                <a href="../../Dashboardfantasma.aspx" class="btn btn-secondary">Error404</a>
                </div>
        </div>

        <div class="container">
            <asp:Panel ID="pnlMensaje" runat="server" Visible="false">
                <div class="alert" id="divMensaje" runat="server">
                    <asp:Label ID="lblMensaje" runat="server"></asp:Label>
                </div>
            </asp:Panel>

            <!-- Formulario de Usuario -->
            <div class="card">
                <h3>Nuevo Usuario</h3>
                <div class="form-inline">
                    <div class="form-group">
                        <label>Nombre de Usuario:</label>
                        <asp:TextBox ID="txtNombreUsuario" runat="server" required></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Contraseña:</label>
                        <asp:TextBox ID="txtContrasena" runat="server" TextMode="Password" required></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Rol:</label>
                        <asp:DropDownList ID="ddlRol" runat="server">
                            <asp:ListItem Value="Admin">Administrador</asp:ListItem>
                            <asp:ListItem Value="Vendedor">Vendedor</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
                        <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-secondary" OnClick="btnCancelar_Click" />
                    </div>
                </div>
                <asp:HiddenField ID="hfIdUsuario" runat="server" Value="0" />
            </div>

            <!-- Lista de Usuarios -->
            <div class="card">
                <h3>Lista de Usuarios</h3>
                <asp:GridView ID="gvUsuarios" runat="server" CssClass="grid" AutoGenerateColumns="false" 
                    OnRowCommand="gvUsuarios_RowCommand" OnRowDataBound="gvUsuarios_RowDataBound" 
                    EmptyDataText="No hay usuarios registrados" DataKeyNames="IdUsuario">
                    <Columns>
                        <asp:BoundField DataField="IdUsuario" HeaderText="ID" />
                        <asp:BoundField DataField="NombreUsuario" HeaderText="Usuario" />
                        <asp:BoundField DataField="Rol" HeaderText="Rol" />
                        <asp:TemplateField HeaderText="Acciones">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEditar" runat="server" Text="Editar" CssClass="btn btn-success" 
                                    CommandName="EditarUsuario" CommandArgument='<%# Eval("IdUsuario") %>' />
                                <asp:LinkButton ID="btnEliminar" runat="server" Text="Eliminar" CssClass="btn btn-danger" 
                                    CommandName="EliminarUsuario" CommandArgument='<%# Eval("IdUsuario") %>' 
                                    OnClientClick="return confirm('¿Está seguro de eliminar este usuario?');" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
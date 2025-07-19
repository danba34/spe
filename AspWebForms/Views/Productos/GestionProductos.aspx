<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GestionProductos.aspx.cs" Inherits="Speedan.Views.Productos.GestionProductos" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Gestión de Productos - Speedan</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; }
        .header { background-color: #007bff; color: white; padding: 15px; display: flex; justify-content: space-between; align-items: center; }
        .container { max-width: 1400px; margin: 20px auto; padding: 0 20px; }
        .card { background: white; border-radius: 8px; padding: 20px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input, .form-group select { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
        
        .btn { padding: 10px 20px; margin: 5px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block; }
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
        .form-inline .form-group { margin-bottom: 0; flex: 1; }
        .low-stock { background-color: #fff3cd !important; color: #856404; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <h1>Gestión de Productos</h1>
            <div>
                <a href="../../Dashboard.aspx" class="btn btn-secondary">Volver al Dashboard</a>
            </div>
        </div>

        <div class="container">
            <asp:Panel ID="pnlMensaje" runat="server" Visible="false">
                <div class="alert" id="divMensaje" runat="server">
                    <asp:Label ID="lblMensaje" runat="server"></asp:Label>
                </div>
            </asp:Panel>

            <!-- Formulario de Producto -->
            <div class="card">
                <h3>Nuevo Producto</h3>
                <div class="form-inline">
                    <div class="form-group">
                        <label>Modelo:</label>
                        <asp:TextBox ID="txtModelo" runat="server"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvModelo" runat="server" 
                            ControlToValidate="txtModelo" 
                            ErrorMessage="El modelo es requerido" 
                            ValidationGroup="ProductoGroup"
                            Display="Dynamic" 
                            ForeColor="Red">*</asp:RequiredFieldValidator>
                    </div>
                    <div class="form-group">
                        <label>Talla:</label>
                        <asp:TextBox ID="txtTalla" runat="server" TextMode="Number" step="0.5"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvTalla" runat="server" 
                            ControlToValidate="txtTalla" 
                            ErrorMessage="La talla es requerida" 
                            ValidationGroup="ProductoGroup"
                            Display="Dynamic" 
                            ForeColor="Red">*</asp:RequiredFieldValidator>
                    </div>
                    <div class="form-group">
                        <label>Color:</label>
                        <asp:TextBox ID="txtColor" runat="server"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvColor" runat="server" 
                            ControlToValidate="txtColor" 
                            ErrorMessage="El color es requerido" 
                            ValidationGroup="ProductoGroup"
                            Display="Dynamic" 
                            ForeColor="Red">*</asp:RequiredFieldValidator>
                    </div>
                    <div class="form-group">
                        <label>Precio:</label>
                        <asp:TextBox ID="txtPrecio" runat="server" TextMode="Number" step="0.01"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvPrecio" runat="server" 
                            ControlToValidate="txtPrecio" 
                            ErrorMessage="El precio es requerido" 
                            ValidationGroup="ProductoGroup"
                            Display="Dynamic" 
                            ForeColor="Red">*</asp:RequiredFieldValidator>
                    </div>
                    <div class="form-group">
                        <label>Stock:</label>
                        <asp:TextBox ID="txtStock" runat="server" TextMode="Number"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvStock" runat="server" 
                            ControlToValidate="txtStock" 
                            ErrorMessage="El stock es requerido" 
                            ValidationGroup="ProductoGroup"
                            Display="Dynamic" 
                            ForeColor="Red">*</asp:RequiredFieldValidator>
                    </div>
                    <div class="form-group">
                        <asp:Button ID="btnGuardar" runat="server" Text="Guardar" 
                            CssClass="btn btn-primary" 
                            OnClick="btnGuardar_Click" 
                            ValidationGroup="ProductoGroup" />
                        <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" 
                            CssClass="btn btn-secondary" 
                            OnClick="btnCancelar_Click" 
                            CausesValidation="false" />
                    </div>
                </div>
                <asp:HiddenField ID="hfIdProducto" runat="server" Value="0" />
            </div>

            <!-- Lista de Productos -->
            <div class="card">
                <h3>Lista de Productos</h3>
                <asp:GridView ID="gvProductos" runat="server" CssClass="grid" AutoGenerateColumns="false" 
                    OnRowCommand="gvProductos_RowCommand" OnRowDataBound="gvProductos_RowDataBound" 
                    EmptyDataText="No hay productos registrados">
                    <Columns>
                        <asp:BoundField DataField="IdProducto" HeaderText="ID" />
                        <asp:BoundField DataField="Modelo" HeaderText="Modelo" />
                        <asp:BoundField DataField="Talla" HeaderText="Talla" />
                        <asp:BoundField DataField="Color" HeaderText="Color" />
                        <asp:BoundField DataField="Precio" HeaderText="Precio" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="Stock" HeaderText="Stock" />
                        <asp:TemplateField HeaderText="Acciones">
                            <ItemTemplate>
                                <asp:Button ID="btnEditar" runat="server" Text="Editar" 
                                    CssClass="btn btn-success" 
                                    CommandName="Editar" 
                                    CommandArgument='<%# Eval("IdProducto") %>' 
                                    CausesValidation="false" />
                                <asp:Button ID="btnEliminar" runat="server" Text="Eliminar" 
                                    CssClass="btn btn-danger" 
                                    CommandName="Eliminar" 
                                    CommandArgument='<%# Eval("IdProducto") %>' 
                                    CausesValidation="false"
                                    OnClientClick="return confirm('¿Está seguro de eliminar este producto?');" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
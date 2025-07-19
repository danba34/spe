<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Speedan.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Speedan - Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; }
        .header { background-color: #007bff; color: white; padding: 15px; display: flex; justify-content: space-between; align-items: center; }
        .container { max-width: 1400px; margin: 20px auto; padding: 0 20px; }
        .card { background: white; border-radius: 8px; padding: 20px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        
        /* Tabs */
        .tabs { display: flex; background: white; border-radius: 8px 8px 0 0; overflow: hidden; margin-bottom: 0; }
        .tab { padding: 15px 25px; background: #f8f9fa; border: none; cursor: pointer; border-right: 1px solid #dee2e6; }
        .tab.active { background: #007bff; color: white; }
        .tab:hover { background: #0056b3; color: white; }
        
        /* Grid */
        .grid { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .grid th, .grid td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        .grid th { background-color: #f8f9fa; font-weight: bold; }
        .grid tr:hover { background-color: #f5f5f5; }
        
        /* Buttons */
        .btn { padding: 10px 20px; margin: 5px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block; }
        .btn-primary { background-color: #007bff; color: white; }
        .btn-success { background-color: #28a745; color: white; }
        .btn-danger { background-color: #dc3545; color: white; }
        .btn-info { background-color: #17a2b8; color: white; }
        .btn:hover { opacity: 0.8; }
        
        /* Stats */
        .stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 20px; }
        .stat-card { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 8px; text-align: center; }
        .stat-number { font-size: 2.5em; font-weight: bold; margin-bottom: 10px; }
        .stat-label { font-size: 1.1em; }
        
        /* Filters */
        .filters { display: flex; gap: 15px; margin-bottom: 20px; align-items: center; }
        .filters select, .filters input { padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <h1>SPEEDAN Dashboard</h1>
            <div>
                <asp:Label ID="lblUsuario" runat="server"></asp:Label>
                <asp:Button ID="btnLogout" runat="server" Text="Cerrar Sesión" CssClass="btn btn-danger" OnClick="btnLogout_Click" />
            </div>
        </div>

        <div class="container">
            <!-- Tabs Navigation -->
            <div class="tabs">
                <asp:Button ID="btnTabPrincipal" runat="server" Text="Panel Principal" CssClass="tab active" OnClick="btnTabPrincipal_Click" />
                <asp:Button ID="btnTabUsuarios" runat="server" Text="Usuarios" CssClass="tab" OnClick="btnTabUsuarios_Click" />
                <asp:Button ID="btnTabProductos" runat="server" Text="Productos" CssClass="tab" OnClick="btnTabProductos_Click" />
                <asp:Button ID="btnTabVentas" runat="server" Text="Ventas" CssClass="tab" OnClick="btnTabVentas_Click" />
            </div>

            <!-- Panel Principal -->
            <div class="card">
                <h2>Panel Principal - Resumen del Sistema</h2>
                
                <!-- Estadísticas -->
                <div class="stats">
                    <div class="stat-card">
                        <div class="stat-number"><asp:Label ID="lblTotalProductos" runat="server">0</asp:Label></div>
                        <div class="stat-label">Total Productos</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number"><asp:Label ID="lblTotalVentas" runat="server">0</asp:Label></div>
                        <div class="stat-label">Total Ventas</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number"><asp:Label ID="lblProductosBajoStock" runat="server">0</asp:Label></div>
                        <div class="stat-label">Productos Bajo Stock</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">$<asp:Label ID="lblTotalIngresos" runat="server">0</asp:Label></div>
                        <div class="stat-label">Total Ingresos</div>
                    </div>
                </div>

                <!-- Filtros -->
                <div class="filters">
                    <label>Vista:</label>
                    <asp:DropDownList ID="ddlVista" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlVista_SelectedIndexChanged">
                        <asp:ListItem Value="ventas" Text="Resumen de Ventas" Selected="True"></asp:ListItem>
                        <asp:ListItem Value="productos" Text="Productos Bajo Stock"></asp:ListItem>
                        <asp:ListItem Value="inventario" Text="Inventario Completo"></asp:ListItem>
                    </asp:DropDownList>
                    
               
                </div>

                <!-- GridView Principal -->
                <asp:GridView ID="gvPrincipal" runat="server" CssClass="grid" AutoGenerateColumns="false" EmptyDataText="No hay datos disponibles">
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
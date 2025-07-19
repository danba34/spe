<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Error500.aspx.cs" Inherits="Speedan.Error500" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Speedan - Error del Servidor</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 0; 
            padding: 0; 
            background-color: #f4f4f4; 
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .error-container {
            background: white;
            border-radius: 8px;
            padding: 60px 40px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 500px;
            width: 90%;
        }
        
        .error-image {
            width: 150px;
            height: 150px;
            margin: 0 auto 30px;
            background: #007bff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 60px;
            color: white;
        }
        
        .error-number {
            font-size: 4em;
            font-weight: bold;
            color: #007bff;
            margin-bottom: 20px;
        }
        
        .error-title {
            font-size: 1.8em;
            color: #333;
            margin-bottom: 20px;
        }
        
        .error-message {
            font-size: 1.1em;
            color: #666;
            margin-bottom: 40px;
            line-height: 1.5;
        }
        
        .btn {
            padding: 15px 30px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 1.1em;
            background-color: #007bff;
            color: white;
            transition: background-color 0.3s;
        }
        
        .btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="error-container">
            <div class="error-image">
                ⚠️
            </div>
            <div class="error-number">500</div>
            <div class="error-title">Error del servidor</div>
            <div class="error-message">
                Ha ocurrido un error interno. Por favor, intenta de nuevo más tarde.
            </div>
            <asp:Button ID="btnVolver" runat="server" Text="Volver al Inicio" 
                       CssClass="btn" OnClick="btnVolver_Click" />
        </div>
    </form>
</body>
</html>
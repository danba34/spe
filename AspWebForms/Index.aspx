<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Speedan.Index" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Speedan - Tienda de Zapatos</title>
    <style>
        :root {
            --primary: #007bff;
            --secondary: #6c757d;
            --light: #f8f9fa;
            --dark: #343a40;
            --success: #28a745;
            --danger: #dc3545;
            --white: #ffffff;
            --gray: #6c757d;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            color: #333;
            line-height: 1.6;
        }
        
        .header {
            background-color: var(--white);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 15px 0;
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .header-content {
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .logo-container {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .logo {
            height: 80px;
        }
        
        .brand-name {
            font-size: 32px;
            font-weight: bold;
            color: var(--primary);
            letter-spacing: 1px;
            text-transform: uppercase;
        }
        
        .hero {
            background: linear-gradient(135deg, rgba(0, 123, 255, 0.1) 0%, rgba(108, 117, 125, 0.1) 100%);
            padding: 80px 0;
            text-align: center;
            margin-bottom: 50px;
        }
        
        .hero-title {
            font-size: 48px;
            font-weight: 700;
            color: var(--dark);
            margin-bottom: 20px;
            line-height: 1.2;
        }
        
        .hero-subtitle {
            font-size: 22px;
            color: var(--gray);
            max-width: 700px;
            margin: 0 auto 40px;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 30px;
            border-radius: 30px;
            text-decoration: none;
            font-weight: 600;
            font-size: 16px;
            transition: all 0.3s;
            cursor: pointer;
            border: none;
        }
        
        .btn-primary {
            background-color: var(--primary);
            color: var(--white);
            box-shadow: 0 4px 15px rgba(0, 123, 255, 0.3);
        }
        
        .btn-primary:hover {
            background-color: #0069d9;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 123, 255, 0.4);
        }
        
        .section-title {
            text-align: center;
            margin-bottom: 50px;
            position: relative;
        }
        
        .section-title h2 {
            font-size: 36px;
            font-weight: 700;
            color: var(--dark);
            display: inline-block;
            background: linear-gradient(135deg, #007bff, #00bfff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            padding-bottom: 15px;
        }
        
        .section-title h2::after {
            content: '';
            position: absolute;
            width: 100px;
            height: 3px;
            background: linear-gradient(90deg, #007bff, #00bfff);
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            border-radius: 3px;
        }
        
        .products {
            padding: 50px 0;
            background-color: var(--white);
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            margin-bottom: 50px;
        }
        
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            padding: 0 20px;
        }
        
        .product-card {
            background-color: var(--white);
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            transition: transform 0.3s, box-shadow 0.3s;
            position: relative;
        }
        
        .product-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
        }
        
        .product-img {
            width: 100%;
            height: 250px;
            object-fit: cover;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }
        
        .product-info {
            padding: 20px;
        }
        
        .product-title {
            font-size: 20px;
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 10px;
        }
        
        .product-price {
            font-size: 22px;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 15px;
        }
        
        .product-desc {
            color: var(--gray);
            margin-bottom: 20px;
            font-size: 15px;
        }
        
        .features {
            padding: 70px 0;
            background-color: #f1f8ff;
        }
        
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            margin-top: 50px;
        }
        
        .feature-card {
            background-color: var(--white);
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            text-align: center;
            transition: transform 0.3s;
        }
        
        .feature-card:hover {
            transform: translateY(-10px);
        }
        
        .feature-icon {
            font-size: 50px;
            color: var(--primary);
            margin-bottom: 20px;
        }
        
        .feature-title {
            font-size: 22px;
            font-weight: 600;
            margin-bottom: 15px;
            color: var(--dark);
        }
        
        .feature-desc {
            color: var(--gray);
            font-size: 16px;
        }
        
        .footer {
            background-color: var(--dark);
            color: var(--white);
            padding: 50px 0 20px;
            text-align: center;
        }
        
        .footer-content {
            margin-bottom: 40px;
        }
        
        .footer-section h3 {
            font-size: 20px;
            margin-bottom: 20px;
            position: relative;
            padding-bottom: 10px;
        }
        
        .footer-section h3::after {
            content: '';
            position: absolute;
            width: 50px;
            height: 2px;
            background-color: var(--primary);
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
        }
        
        .contact-info {
            color: #adb5bd;
            margin-bottom: 20px;
        }
        
        .contact-info p {
            margin-bottom: 10px;
        }
        
        .footer-bottom {
            padding-top: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            font-size: 14px;
            color: #adb5bd;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .hero-title {
                font-size: 36px;
            }
            
            .hero-subtitle {
                font-size: 18px;
            }
            
            .logo {
                height: 60px;
            }
            
            .brand-name {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Header con logo centrado -->
        <header class="header">
            <div class="container">
                <div class="header-content">
                    <div class="logo-container">
                        <img src="Imagenes/logo.jpeg" alt="Speedan Logo" class="logo" />
                        <div class="brand-name">SPEEDAN</div>
                    </div>
                </div>
            </div>
        </header>

        <!-- Hero Section -->
        <section class="hero">
            <div class="container">
                <h1 class="hero-title">Los mejores zapatos deportivos en un solo lugar</h1>
                <p class="hero-subtitle">Speedan ofrece calzado de alta calidad con tecnología avanzada para maximizar tu rendimiento y comodidad.</p>
                <a href="Login.aspx" class="btn btn-primary">Acceder al Sistema</a>
            </div>
        </section>

        <!-- Featured Products -->
        <section class="products">
            <div class="container">
                <div class="section-title">
                    <h2>Productos Destacados</h2>
                </div>
                
                <div class="product-grid">
                    <!-- Product 1 -->
                    <div class="product-card">
                        <img src="Imagenes/zapato1.jpeg" alt="Zapato Speedan Runner" class="product-img" />
                        <div class="product-info">
                            <h3 class="product-title">Speedan Runner Pro</h3>
                            <div class="product-price">$380.000</div>
                            <p class="product-desc">Zapatillas de running con tecnología de amortiguación avanzada para máxima comodidad en tus carreras.</p>
                        </div>
                    </div>
                    
                    <!-- Product 2 -->
                    <div class="product-card">
                        <img src="Imagenes/zapato2.jpeg" alt="Zapato Speedan Urban" class="product-img" />
                        <div class="product-info">
                            <h3 class="product-title">Speedan Urban Style</h3>
                            <div class="product-price">$302.200</div>
                            <p class="product-desc">Diseño urbano con comodidad todo el día. Perfecto para el uso diario con estilo moderno.</p>
                        </div>
                    </div>

                </div>
            </div>
        </section>

        <!-- Features -->
        <section class="features">
            <div class="container">
                <div class="section-title">
                    <h2>Por qué elegir Speedan</h2>
                </div>
                
                <div class="features-grid">
                    <div class="feature-card">
                        <div class="feature-icon">✓</div>
                        <h3 class="feature-title">Calidad Premium</h3>
                        <p class="feature-desc">Materiales de primera calidad que garantizan durabilidad y máximo rendimiento.</p>
                    </div>
                    
                    <div class="feature-card">
                        <div class="feature-icon">👟</div>
                        <h3 class="feature-title">Comodidad Superior</h3>
                        <p class="feature-desc">Diseños ergonómicos que se adaptan a tu pie para una experiencia única de confort.</p>
                    </div>
                    
                    <div class="feature-card">
                        <div class="feature-icon">🏆</div>
                        <h3 class="feature-title">Garantía Speedan</h3>
                        <p class="feature-desc">Todos nuestros productos tienen garantía de 1 año contra defectos de fabricación.</p>
                    </div>
                    
                    <div class="feature-card">
                        <div class="feature-icon">🚚</div>
                        <h3 class="feature-title">Envío Rápido</h3>
                        <p class="feature-desc">Recibe tus productos en 24-48 horas en la ciudad de México y área metropolitana.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer class="footer">
            <div class="container">
                <div class="footer-content">
                    <div class="footer-section">
                        <h3>Speedan - Tienda de Zapatos</h3>
                        <div class="contact-info">
                            <p>📍 Colombia</p>
                            <p>📞 (57) 3244628057</p>
                            <p>🕒 Lunes a Sábado: 10:00 - 20:00</p>
                        </div>
                    </div>
                </div>
                
                <div class="footer-bottom">
                    <p>&copy; 2023 Speedan. Todos los derechos reservados.</p>
                </div>
            </div>
        </footer>
    </form>
</body>
</html>
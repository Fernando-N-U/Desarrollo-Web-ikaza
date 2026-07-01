<%-- 
    Document   : comprobante_pedido.jsp
    Created on : 26 may. 2026, 17:53:12
    Author     : LISET
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Comprobante de Pedido #${param.id}</title>
    <link href="${pageContext.request.contextPath}/assets/css/estilos.css" rel="stylesheet">
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; color: #333; }
        .header { text-align: center; border-bottom: 2px solid #000; padding-bottom: 20px; margin-bottom: 30px; }
        .detalle { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .detalle th, .detalle td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        .total { font-size: 1.5em; font-weight: bold; text-align: right; margin-top: 20px; }
        .footer { text-align: center; font-size: 0.9em; margin-top: 50px; color: #666; }
        
        /* Ocultar botones al imprimir */
        @media print {
            .no-print { display: none; }
        }
    </style>
</head>
<body onload="window.print()">
    
    <div class="no-print" style="margin-bottom: 20px; text-align: right;">
        <button onclick="window.print()" style="padding: 10px 20px; cursor:pointer;">Imprimir nuevamente</button>
    </div>

    <div class="header">
        <h1>IKAZA MUEBLERÍA</h1>
        <h3>Comprobante Interno de Entrega Finalizada</h3>
    </div>

    <div>
        <p><strong>Nº de Pedido:</strong> #${param.id}</p>
        <p><strong>Cliente:</strong> ${param.cliente}</p>
        <p><strong>Fecha de Transacción original:</strong> ${param.fecha}</p>
        <p><strong>Estado Actual:</strong> FINALIZADO</p>
    </div>

    <table class="detalle">
        <thead>
            <tr>
                <th>Concepto / Resumen de Compra</th>
                <th style="width: 150px; text-align: right;">Importe</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Pago por productos según registro del sistema web</td>
                <td style="text-align: right;">S/ ${param.total}</td>
            </tr>
        </tbody>
    </table>

    <div class="total">
        TOTAL PAGADO: S/ ${param.total}
    </div>

    <div class="footer">
        <p>Este comprobante es de uso interno administrativo. Certifica que el pedido pasó por los estados: Espera -> En Camino -> Enviado -> Finalizado satisfactoriamente.</p>
        <p>&copy; 2026 Ikaza Sistema de Gestión</p>
    </div>
</body>
</html>

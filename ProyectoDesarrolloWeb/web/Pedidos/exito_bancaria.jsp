<%-- 
    Document   : exito_bancaria
    Created on : 25 jun. 2026
    Author     : LISET
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pedido Recibido - Ikaza</title>
    <link href="${pageContext.request.contextPath}/assets/css/estilos.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <div class="container">
            <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/IndexServlet">IKAZA</a>
        </div>
    </nav>

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-7">
                <div class="card border-0 shadow-sm p-4 text-center bg-white">
                    <div class="mb-4">
                        <i class="bi bi-clock-history text-warning" style="font-size: 4rem;"></i>
                    </div>
                    <h2 class="fw-bold mb-3">¡Pedido Recibido!</h2>
                    <p class="text-muted mb-4">Tu orden ha sido registrada en el sistema con el estado: <span class="badge bg-warning text-dark fw-bold fs-6">Espera</span></p>
                    
                    <div class="card bg-light border-0 p-4 mb-4 text-start">
                        <h5 class="fw-bold text-center mb-3"><i class="bi bi-bank me-2 text-primary"></i> Datos de Transferencia Bancaria</h5>
                        <p class="text-center small mb-4 text-muted">Por favor, realiza el depósito en cualquiera de nuestras cuentas oficiales en un plazo máximo de 24 horas:</p>
                        
                        <div class="table-responsive">
                            <table class="table table-bordered bg-white align-middle">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Banco</th>
                                        <th>Número de Cuenta</th>
                                        <th>Código Interbancario (CCI)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="fw-bold text-primary">BCP</td>
                                        <td>191-98765432-0-11</td>
                                        <td>002-19119876543201153</td>
                                    </tr>
                                    <tr>
                                        <td class="fw-bold text-success">BBVA</td>
                                        <td>0011-0345-0100067890</td>
                                        <td>011-34500010006789024</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="text-center mt-2">
                            <span class="text-muted small"><strong>Titular de las cuentas:</strong> IKAZA MUEBLES S.A.C.</span>
                        </div>
                    </div>

                    <div class="alert alert-success border-0 shadow-sm d-flex align-items-center text-start mb-4" role="alert">
                        <i class="bi bi-whatsapp text-success me-3 fs-2"></i>
                        <div>
                            <strong>¡Importante!</strong> Una vez realizada la transferencia, envía la foto del voucher o captura de pantalla vía WhatsApp para procesar la verificación y validar tu pedido.
                        </div>
                    </div>

                    <a href="${pageContext.request.contextPath}/IndexServlet" class="btn btn-primary btn-lg w-100 fw-bold shadow-sm">
                        <i class="bi bi-house-door me-2"></i> Volver al Inicio
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

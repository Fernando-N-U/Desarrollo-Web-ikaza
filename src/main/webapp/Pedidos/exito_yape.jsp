<%-- 
    Document   : exito_yape
    Created on : 25 may. 2026, 23:55:18
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
            <a class="navbar-brand fw-bold" href="IndexServlet">IKAZA</a>
        </div>
    </nav>

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card border-0 shadow-sm p-4 text-center bg-white">
                    <div class="mb-4">
                        <i class="bi bi-clock-history text-warning" style="font-size: 4rem;"></i>
                    </div>
                    <h2 class="fw-bold mb-3">¡Pedido Recibido!</h2>
                    <p class="text-muted mb-4">Tu orden ha sido registrada en el sistema con el estado: <span class="badge bg-warning text-dark fw-bold fs-6">Espera</span></p>
                    
                    <div class="card bg-light border-0 p-3 mb-4 text-start">
                        <h5 class="fw-bold text-center mb-3"><i class="bi bi-qr-code me-2"></i> Paga con Yape o Plin</h5>
                        <p class="text-center small mb-3 text-muted">Escanea el código QR o realiza la transferencia al número celular (esto debe realizarse en menos de 24 horas): </p>
                        
                        <div class="text-center mb-2">
                            <div class="mb-2">
                                <img src="${pageContext.request.contextPath}/assets/img/qr_yape.jpeg" alt="QR Yape Ikaza" class="img-fluid border border-3 rounded" style="max-width: 200px;">
                            </div>
                            <h4 class="fw-bold mt-2 text-dark">919 591 559</h4>
                            <span class="text-muted small">Titular: IKAZA Muebles</span>
                        </div>
                    </div>

                    <div class="alert alert-success border-0 shadow-sm d-flex align-items-center text-start mb-4" role="alert">
                        <i class="bi bi-whatsapp text-success me-3 fs-2"></i>
                        <div>
                            <strong>¡Importante!</strong> Una vez pagado el pedido, alguien se va a comunicar vía WhatsApp contigo para informarte sobre su estado y coordinar los detalles.
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

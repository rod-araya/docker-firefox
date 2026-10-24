# 🔄 Migración de julz.nosotrosemprendemos.cl a julz.qzz.io

## 📊 Resumen del Cambio

**Dominio Anterior**: julz.nosotrosemprendemos.cl  
**Dominio Nuevo**: julz.qzz.io (dominio gratuito)  
**Fecha de Migración**: 2025-11-02

---

## ✅ PASOS COMPLETADOS

### 1. ✅ Configuración de Caddy Actualizada

Archivo: `/opt/projects/notifuse/Caddyfile`

```caddyfile
julz.qzz.io {
    encode gzip
    reverse_proxy firefox:5800
    
    reverse_proxy /websockify firefox:5800 {
        header_up Host {host}
        header_up X-Real-IP {remote}
    }
    
    reverse_proxy /websockify-audio firefox:5800 {
        header_up Host {host}
        header_up X-Real-IP {remote}
    }
}
```

### 2. ✅ Caddy Reiniciado

El servidor está listo para recibir tráfico en el nuevo dominio.

---

## 📋 PASOS PENDIENTES (Debes Hacer Tú)

### PASO 1: Registrar el Dominio julz.qzz.io

En el formulario de registro que tienes abierto:

```
Name Server 1: ns1.cloudflare.com
Name Server 2: ns2.cloudflare.com
```

**IMPORTANTE**: Si el servicio qzz.io usa sus propios nameservers, úsalos en su lugar.

---

### PASO 2: Configurar DNS

#### Opción A: Si usas Cloudflare

1. Ve a https://dash.cloudflare.com
2. Agrega el sitio: `qzz.io`
3. En **DNS** → **Records**, agrega:
   ```
   Type: A
   Name: julz
   IPv4 address: 46.62.213.138
   Proxy status: DNS only (🟧 gris, NO naranja)
   TTL: Auto
   ```

#### Opción B: Si qzz.io tiene su propio panel DNS

1. Busca la sección **DNS Management** en el panel de qzz.io
2. Agrega un registro A:
   ```
   Host/Name: julz
   Type: A
   Value/Points to: 46.62.213.138
   TTL: 3600 (o automático)
   ```

---

### PASO 3: Esperar Propagación DNS (5-30 minutos)

Verifica cuando esté listo:

```bash
# Desde tu servidor
dig julz.qzz.io +short

# Debería mostrar:
# 46.62.213.138
```

**Desde tu Mac:**
```bash
dig julz.qzz.io +short @8.8.8.8
```

---

### PASO 4: Probar Acceso

Una vez que el DNS esté propagado:

```bash
# Verificar que responde
curl -I https://julz.qzz.io

# Debería mostrar:
# HTTP/2 200
```

Luego abre en tu navegador:
```
https://julz.qzz.io
```

---

## 🔍 Verificación y Troubleshooting

### Verificar DNS:
```bash
# Ver DNS actual
dig julz.qzz.io +short

# Verificar nameservers
dig qzz.io NS +short
```

### Ver logs de Caddy:
```bash
docker logs caddy-notifuse --tail 50 | grep qzz
```

### Verificar certificado SSL:
```bash
# Caddy obtendrá automáticamente el certificado
docker logs caddy-notifuse --tail 100 | grep -E "(certificate|julz.qzz.io)"
```

---

## ⚠️ Problemas Comunes

### Problema 1: DNS no resuelve

**Causa**: El dominio aún no está registrado o el DNS no se propagó.

**Solución**: 
- Espera 30 minutos
- Verifica que completaste el registro del dominio
- Confirma que agregaste el registro A correctamente

### Problema 2: Error 403/404

**Causa**: El DNS apunta a otro servidor.

**Solución**:
```bash
# Verificar a dónde apunta
dig julz.qzz.io +short

# Debe ser: 46.62.213.138
```

### Problema 3: Certificado SSL no se obtiene

**Causa**: Cloudflare proxy activado (naranja).

**Solución**:
- Ve a Cloudflare DNS
- Asegúrate que el registro A esté en **DNS only** (gris, no naranja)

---

## 📊 Comparación de Dominios

| Característica | nosotrosemprendemos.cl | qzz.io |
|----------------|------------------------|--------|
| Costo | Pagado (dominio existente) | ✅ Gratis |
| Control | Limitado (cPanel) | ✅ Más flexible |
| SSL | ✅ Funcionando | ✅ Automático con Caddy |
| Propagación DNS | Más lento | Más rápido |

---

## 🔄 Si Quieres Mantener Ambos Dominios

Puedes agregar ambos al Caddyfile para que funcionen al mismo tiempo:

```caddyfile
# Dominio nuevo (principal)
julz.qzz.io {
    encode gzip
    reverse_proxy firefox:5800
    reverse_proxy /websockify firefox:5800 {
        header_up Host {host}
        header_up X-Real-IP {remote}
    }
    reverse_proxy /websockify-audio firefox:5800 {
        header_up Host {host}
        header_up X-Real-IP {remote}
    }
}

# Dominio antiguo (redirección o funcional)
julz.nosotrosemprendemos.cl {
    redir https://julz.qzz.io{uri} permanent
}
```

Luego reiniciar Caddy:
```bash
cd /opt/projects/notifuse
docker restart caddy-notifuse
```

---

## 🎯 Próximos Pasos Recomendados

1. ✅ **Completa el registro** del dominio julz.qzz.io
2. ✅ **Configura el DNS** (Cloudflare o panel de qzz.io)
3. ⏳ **Espera propagación** (5-30 minutos)
4. 🧪 **Prueba el acceso**: https://julz.qzz.io
5. 🎉 **¡Disfruta tu nuevo dominio gratuito!**

---

## 📞 Información Técnica

### Servidor:
- **IP**: 46.62.213.138
- **Puerto HTTP**: 80
- **Puerto HTTPS**: 443
- **Puerto Firefox (interno)**: 5800

### Configuración:
- **Caddyfile**: `/opt/projects/notifuse/Caddyfile`
- **Docker Compose Firefox**: `/opt/projects/firefox-docker/docker-compose.yml`
- **Caddy Container**: `caddy-notifuse`
- **Firefox Container**: `firefox`

### Comandos Útiles:
```bash
# Reiniciar Caddy
docker restart caddy-notifuse

# Ver logs de Caddy
docker logs caddy-notifuse --tail 50

# Verificar DNS
dig julz.qzz.io +short

# Probar HTTPS
curl -I https://julz.qzz.io
```

---

**Estado**: ✅ Configuración de servidor completada, esperando configuración DNS del usuario.




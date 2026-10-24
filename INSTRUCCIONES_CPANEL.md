# Instrucciones para Configurar julz.nosotrosemprendemos.cl en cPanel

## Configuración en cPanel

### Opción 1: Crear Subdominio (Recomendado)

1. **Accede a cPanel** de tu cuenta de hosting
2. Ve a **"Subdominios"** (Subdomains)
3. En el campo **"Subdominio"**, ingresa: `julz`
4. En el campo **"Dominio"**, selecciona: `nosotrosemprendemos.cl`
5. En **"Directorio de Documentos"**, puedes usar el predeterminado o crear uno específico (ej: `public_html/julz`)
6. Haz clic en **"Crear"**

### Opción 2: Configurar DNS Manualmente (Si no tienes acceso a cPanel)

Si prefieres configurar el DNS manualmente:

1. Ve a la zona DNS de `nosotrosemprendemos.cl`
2. Agrega un registro **A** o **CNAME**:
   - **Tipo**: A (si tienes IP fija) o CNAME (si apunta a otro dominio)
   - **Nombre**: `julz`
   - **Valor**: La IP de tu servidor Florencia (donde está Caddy)
   - **TTL**: 3600 (o el predeterminado)

### ⚠️ IMPORTANTE: Configuración de DNS

**NO necesitas configurar nada más en cPanel** porque:
- Caddy ya está configurado para manejar el dominio `julz.nosotrosemprendemos.cl`
- Caddy manejará automáticamente los certificados SSL (Let's Encrypt)
- El proxy reverso está configurado en el Caddyfile

### Verificación

Después de crear el subdominio en cPanel o configurar el DNS:

1. Espera unos minutos para que el DNS se propague
2. Verifica que el DNS apunta correctamente:
   ```bash
   dig julz.nosotrosemprendemos.cl
   # o
   nslookup julz.nosotrosemprendemos.cl
   ```
3. Una vez que el DNS esté configurado, Caddy automáticamente:
   - Obtendrá un certificado SSL de Let's Encrypt
   - Configurará el proxy reverso a Firefox

### Notas Adicionales

- **Puerto**: No necesitas abrir puertos adicionales en el firewall porque Caddy ya maneja los puertos 80 y 443
- **SSL**: Caddy obtendrá automáticamente el certificado SSL cuando detecte el dominio
- **Proxy**: El proxy reverso ya está configurado en `/opt/projects/notifuse/Caddyfile`

### Si el DNS no está configurado aún

Si intentas acceder a `julz.nosotrosemprendemos.cl` antes de configurar el DNS, verás un error. 
Una vez configurado el DNS en cPanel, Caddy detectará automáticamente el nuevo dominio y configurará SSL.












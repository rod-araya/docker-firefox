# 📘 Guía Paso a Paso: Configurar DNS en cPanel

## 🎯 Objetivo
Cambiar el registro DNS de `julz.nosotrosemprendemos.cl` para que apunte a tu servidor con IP `46.62.213.138`

---

## 📋 Pasos en cPanel

### 1. Acceder a cPanel

1. Ve a la URL de cPanel de tu hosting (ejemplo: `cpanel.tuhosting.com`)
2. Ingresa con tu usuario y contraseña
3. Una vez dentro, busca la sección **"Dominios"** o **"Domains"**

---

### 2. Acceder al Editor de Zona DNS

Busca una de estas opciones (depende de tu versión de cPanel):
- **"Zone Editor"** (versión en inglés)
- **"Editor de Zona DNS"** (versión en español)
- **"DNS Zone Editor"**
- **"Advanced DNS Zone Editor"**

Haz clic en ella.

---

### 3. Seleccionar el Dominio

1. En el Editor de Zona DNS, busca el dominio: **`nosotrosemprendemos.cl`**
2. Si tienes varios dominios, asegúrate de seleccionar el correcto
3. Haz clic en **"Administrar"** o **"Manage"**

---

### 4. Buscar el Registro del Subdominio

En la lista de registros DNS, busca:
- **Nombre**: `julz` o `julz.nosotrosemprendemos.cl`
- **Tipo**: A
- **Dirección/Address**: `192.185.91.120` ← Este es el valor incorrecto

---

### 5. Editar el Registro A

#### Opción A: Si existe el registro

1. Haz clic en **"Editar"** o el ícono de lápiz ✏️ junto al registro
2. En el campo **"Address"** o **"Dirección"**, cambia:
   - ❌ Valor actual: `192.185.91.120`
   - ✅ Valor nuevo: `46.62.213.138`
3. Deja el TTL en su valor predeterminado (3600 o 14400)
4. Haz clic en **"Save Record"** o **"Guardar"**

#### Opción B: Si NO existe el registro

1. Haz clic en **"Add Record"** o **"Agregar Registro"**
2. Configura:
   - **Nombre**: `julz`
   - **Tipo**: A
   - **Dirección**: `46.62.213.138`
   - **TTL**: 3600 (o deja el predeterminado)
3. Haz clic en **"Agregar Registro"** o **"Add Record"**

---

### 6. Verificar el Cambio

Después de guardar, deberías ver en la lista:
```
Nombre: julz
Tipo: A
Dirección: 46.62.213.138
TTL: 3600
```

✅ Si ves esto, ¡perfecto!

---

## ⏱️ Tiempo de Propagación

Después de hacer el cambio:
- **Mínimo**: 5-10 minutos
- **Máximo**: 24-48 horas (raro)
- **Normal**: 15-30 minutos

---

## 🔍 Verificar la Propagación

Desde tu servidor, ejecuta:

```bash
/opt/projects/firefox-docker/verificar-dns.sh
```

O manualmente:
```bash
dig julz.nosotrosemprendemos.cl +short
```

Debe mostrar: `46.62.213.138`

---

## 🚀 Después de la Propagación

Una vez que el DNS esté correcto:

```bash
cd /opt/projects/notifuse
docker restart caddy-notifuse
```

Espera 1-2 minutos y luego accede a:
```
https://julz.nosotrosemprendemos.cl
```

¡Debería funcionar perfectamente! 🎉

---

## ❓ Alternativas si No Tienes Acceso a cPanel

### 1. Si usas Cloudflare

1. Ve a cloudflare.com e inicia sesión
2. Selecciona `nosotrosemprendemos.cl`
3. Ve a **DNS** > **Records**
4. Edita el registro A de `julz`
5. Cambia a `46.62.213.138`
6. ⚠️ **IMPORTANTE**: Desactiva el proxy (nube naranja → gris)

### 2. Si usas otro proveedor de DNS

El proceso es similar:
1. Accede al panel de tu proveedor DNS
2. Busca la zona DNS de `nosotrosemprendemos.cl`
3. Edita el registro A de `julz`
4. Cambia a `46.62.213.138`

### 3. Si no tienes acceso

Contacta a:
- Tu proveedor de hosting
- El administrador del dominio `nosotrosemprendemos.cl`
- El administrador de sistemas de tu empresa

---

## 🆘 ¿Problemas?

Si después de 1 hora el DNS no se actualiza:

1. **Verifica que guardaste los cambios**
   ```bash
   dig julz.nosotrosemprendemos.cl +short
   ```

2. **Limpia tu caché DNS local**
   ```bash
   # Linux
   sudo systemd-resolve --flush-caches
   
   # Mac
   sudo dscacheutil -flushcache
   
   # Windows
   ipconfig /flushdns
   ```

3. **Verifica en línea**
   - https://dnschecker.org/#A/julz.nosotrosemprendemos.cl
   - Debe mostrar `46.62.213.138` en todos los servidores

4. **Revisa los logs de Caddy**
   ```bash
   docker logs caddy-notifuse --tail 100
   ```
   
   Busca mensajes de éxito como:
   ```
   "msg":"certificate obtained successfully"
   ```

---

## 📞 Contacto

Si necesitas ayuda adicional, puedes:
1. Revisar los logs con `docker logs caddy-notifuse`
2. Ejecutar el script de diagnóstico: `/opt/projects/firefox-docker/verificar-dns.sh`
3. Contactar a tu proveedor de hosting para ayuda con el DNS


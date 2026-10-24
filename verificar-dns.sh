#!/bin/bash

# Script para verificar y diagnosticar el problema de DNS de julz.nosotrosemprendemos.cl

echo "🔍 DIAGNÓSTICO DE DNS Y CONECTIVIDAD"
echo "===================================="
echo ""

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. IP del servidor actual
echo "1️⃣  IP de este servidor:"
SERVER_IP=$(hostname -I | awk '{print $1}')
echo -e "   ${GREEN}${SERVER_IP}${NC}"
echo ""

# 2. IP en DNS
echo "2️⃣  IP configurada en DNS para julz.nosotrosemprendemos.cl:"
DNS_IP=$(dig +short julz.nosotrosemprendemos.cl | head -n1)
if [ -z "$DNS_IP" ]; then
    echo -e "   ${RED}❌ No se puede resolver el DNS${NC}"
else
    echo -e "   ${YELLOW}${DNS_IP}${NC}"
fi
echo ""

# 3. Comparación
echo "3️⃣  Verificación:"
if [ "$SERVER_IP" == "$DNS_IP" ]; then
    echo -e "   ${GREEN}✅ ¡DNS configurado correctamente!${NC}"
    echo ""
    echo "   El DNS apunta a este servidor. Reinicia Caddy para obtener el certificado:"
    echo -e "   ${GREEN}cd /opt/projects/notifuse && docker restart caddy-notifuse${NC}"
else
    echo -e "   ${RED}❌ DNS incorrecto - El dominio NO apunta a este servidor${NC}"
    echo ""
    echo "   📝 Debes cambiar el registro A en cPanel:"
    echo "   - Dominio: julz.nosotrosemprendemos.cl"
    echo "   - Tipo: A"
    echo -e "   - Valor actual: ${RED}${DNS_IP}${NC}"
    echo -e "   - Valor correcto: ${GREEN}${SERVER_IP}${NC}"
fi
echo ""

# 4. Estado de Firefox
echo "4️⃣  Estado del contenedor Firefox:"
if docker ps | grep -q "firefox"; then
    echo -e "   ${GREEN}✅ Firefox está corriendo${NC}"
    echo "   Accesible localmente en: http://localhost:5800"
else
    echo -e "   ${RED}❌ Firefox no está corriendo${NC}"
    echo "   Iniciarlo con: cd /opt/projects/firefox-docker && docker-compose up -d"
fi
echo ""

# 5. Estado de Caddy
echo "5️⃣  Estado de Caddy:"
if docker ps | grep -q "caddy-notifuse"; then
    echo -e "   ${GREEN}✅ Caddy está corriendo${NC}"
    
    # Verificar errores en los últimos logs
    ERROR_COUNT=$(docker logs caddy-notifuse --tail 50 2>&1 | grep -c "level.*error")
    if [ "$ERROR_COUNT" -gt 0 ]; then
        echo -e "   ${YELLOW}⚠️  Hay ${ERROR_COUNT} errores en los últimos logs${NC}"
        echo "   Ver logs: docker logs caddy-notifuse --tail 50"
    fi
else
    echo -e "   ${RED}❌ Caddy no está corriendo${NC}"
fi
echo ""

# 6. Accesos disponibles AHORA
echo "6️⃣  Accesos disponibles AHORA:"
echo "   📍 Acceso directo (siempre funciona):"
echo -e "   ${GREEN}http://${SERVER_IP}:5800${NC}"
echo ""
if [ "$SERVER_IP" == "$DNS_IP" ]; then
    echo "   🌐 Acceso por dominio (debería funcionar pronto):"
    echo -e "   ${GREEN}https://julz.nosotrosemprendemos.cl${NC}"
    echo "   (Espera 1-2 minutos después de reiniciar Caddy para el certificado SSL)"
else
    echo "   🌐 Acceso por dominio:"
    echo -e "   ${RED}https://julz.nosotrosemprendemos.cl - NO FUNCIONA AÚN${NC}"
    echo "   (Primero debes arreglar el DNS)"
fi
echo ""

# 7. Siguiente paso
echo "7️⃣  SIGUIENTE PASO:"
if [ "$SERVER_IP" == "$DNS_IP" ]; then
    echo -e "   ${GREEN}DNS correcto. Reinicia Caddy:${NC}"
    echo "   cd /opt/projects/notifuse && docker restart caddy-notifuse"
else
    echo -e "   ${YELLOW}1. Ve a cPanel de nosotrosemprendemos.cl${NC}"
    echo -e "   ${YELLOW}2. Edita el registro A de 'julz'${NC}"
    echo -e "   ${YELLOW}3. Cambia la IP de ${DNS_IP} a ${SERVER_IP}${NC}"
    echo -e "   ${YELLOW}4. Espera 5-10 minutos${NC}"
    echo -e "   ${YELLOW}5. Vuelve a ejecutar este script para verificar${NC}"
fi
echo ""

echo "📄 Documentación completa: /opt/projects/firefox-docker/SOLUCION_403.md"
echo ""


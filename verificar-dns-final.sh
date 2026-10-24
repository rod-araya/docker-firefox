#!/bin/bash

echo "🔍 Verificando DNS después de eliminar registro duplicado..."
echo ""

# Esperar un poco por si acaso
sleep 3

echo "1️⃣  Verificando DNS desde diferentes servidores:"
echo ""

echo "   Google DNS (8.8.8.8):"
DNS_GOOGLE=$(dig +short julz.nosotrosemprendemos.cl @8.8.8.8 | sort | uniq)
echo "   $DNS_GOOGLE"
echo ""

echo "   Cloudflare DNS (1.1.1.1):"
DNS_CLOUDFLARE=$(dig +short julz.nosotrosemprendemos.cl @1.1.1.1 | sort | uniq)
echo "   $DNS_CLOUDFLARE"
echo ""

echo "   DNS Local:"
DNS_LOCAL=$(dig +short julz.nosotrosemprendemos.cl | sort | uniq)
echo "   $DNS_LOCAL"
echo ""

# Contar cuántas IPs únicas hay
IP_COUNT=$(dig +short julz.nosotrosemprendemos.cl | sort | uniq | wc -l)

echo "2️⃣  Resultado:"
if [ "$IP_COUNT" -eq 1 ]; then
    IP=$(dig +short julz.nosotrosemprendemos.cl | head -1)
    if [ "$IP" = "46.62.213.138" ]; then
        echo "   ✅ ¡PERFECTO! Solo una IP y es la correcta: 46.62.213.138"
        echo ""
        echo "3️⃣  Próximo paso:"
        echo "   Espera hasta las 21:26 UTC (8 minutos desde ahora)"
        echo "   Luego ejecuta: docker restart caddy-notifuse"
    else
        echo "   ⚠️  Solo una IP pero es incorrecta: $IP"
        echo "   Debería ser: 46.62.213.138"
    fi
elif [ "$IP_COUNT" -eq 2 ]; then
    echo "   ❌ Aún hay DOS IPs en el DNS:"
    echo "   $DNS_LOCAL"
    echo ""
    echo "   Verifica en cPanel que eliminaste el registro correcto"
    echo "   Espera 5-10 minutos más para propagación"
else
    echo "   ⚠️  Situación inesperada: $IP_COUNT IPs encontradas"
fi

echo ""
echo "🔄 Ejecuta este script nuevamente en unos minutos si aún hay 2 IPs"


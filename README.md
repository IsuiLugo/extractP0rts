# Funcionalidad ExtractPorts.sh

Esta funcionalidad sirve para extraer el total de puertos, imprimirlos en consola y copiarlos a la clipboard, del resultado de un escaneo de `nmap`, el script está inspirado en la herramienta desarrollada por [S4vitar](https://www.youtube.com/c/s4vitar)  en sus directos. La diferencia es el lenguaje de programación y un poco más simplicidad.

![](https://github.com/IsuiLugo/extractP0rts/blob/main/Pasted%20image%2020240718155156.png?raw=true)

El comando de `nmap` que suelo utilizar en muchas practicas es el siguiente:

```python
sudo nmap -p- --open -sS --min-rate 1000 -vv -n -Pn ip_target -oG generalScan
```

Que arroja un resultado como el siguiente ejemplo:

```python
┌──(isui㉿kali)-[~/TryHackMe/Blue]
└─$ sudo nmap -p- --open -sS --min-rate 1000 -vv -n -Pn 10.10.42.187 -oG generalPorts 
[sudo] password for isui: 
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times may be slower.
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-07-18 14:45 CST
Initiating SYN Stealth Scan at 14:45
Scanning 10.10.42.187 [65535 ports]
Discovered open port 3389/tcp on 10.10.42.187
Discovered open port 139/tcp on 10.10.42.187
Discovered open port 135/tcp on 10.10.42.187
Discovered open port 445/tcp on 10.10.42.187
Discovered open port 49152/tcp on 10.10.42.187
Discovered open port 49154/tcp on 10.10.42.187
Discovered open port 49159/tcp on 10.10.42.187
Discovered open port 49158/tcp on 10.10.42.187
Discovered open port 49153/tcp on 10.10.42.187
Completed SYN Stealth Scan at 14:46, 51.08s elapsed (65535 total ports)
Nmap scan report for 10.10.42.187
Host is up, received user-set (0.16s latency).
Scanned at 2024-07-18 14:45:22 CST for 51s
Not shown: 65526 closed tcp ports (reset)
PORT      STATE SERVICE       REASON
135/tcp   open  msrpc         syn-ack ttl 127
139/tcp   open  netbios-ssn   syn-ack ttl 127
445/tcp   open  microsoft-ds  syn-ack ttl 127
3389/tcp  open  ms-wbt-server syn-ack ttl 127
49152/tcp open  unknown       syn-ack ttl 127
49153/tcp open  unknown       syn-ack ttl 127
49154/tcp open  unknown       syn-ack ttl 127
49158/tcp open  unknown       syn-ack ttl 127
49159/tcp open  unknown       syn-ack ttl 127

Read data files from: /usr/bin/../share/nmap
Nmap done: 1 IP address (1 host up) scanned in 51.18 seconds
           Raw packets sent: 71909 (3.164MB) | Rcvd: 71644 (2.866MB)
```

En base a esos resultados, que generalmente son muy parecidos siempre, es como desarrollé el Script, para que cumpla con mis necesidades. Como se puede notar, en este tipo de escaneo, no busco ser exageradamente intrusivo, seguramente se puede ser menos intrusivo con el parámetro `safe` de `nmap`, pero también busco que sea veloz el escaneo. Lo que conlleva a no exponer ninguna versión de los servicios.

# Instalación

Actualizar el sistema:

```sh
sudo apt update
```

### Instalar XCLIP:

Para instalar `xclip` (no `xclipboard`, que es una aplicación diferente) en tu sistema, puedes usar el gestor de paquetes correspondiente a tu distribución de Linux. Aquí te dejo los comandos para las distribuciones más comunes:

#### En Debian/Ubuntu y derivadas (Kali & Parrot)

```sh
sudo apt update
sudo apt install xclip
```

#### En Fedora

```sh
sudo dnf install xclip
```

#### En Arch Linux y derivadas (como Manjaro)

```sh
sudo pacman -S xclip
```

#### Verificar la instalación

Después de instalar `xclip`, puedes verificar que esté instalado correctamente ejecutando:

```sh
xclip -version
```

# Crear Script en Bash

Crear un archivo que se llame `extractPorts.sh` con su editor de código preferido (nano, vim, pico, code, etc), ejemplo:

```python
nano extractPorts.sh
```

Pegar el siguiente código:

```bash
#!/bin/zsh

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # Sin color

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo -e "${RED}Usage: $0 <nmap_output_file>${NC}"
    exit 1
fi

FILE=$1

# Extract open ports and copy to clipboard
PORTS=$(grep -oP '\d+/open/tcp/\S+' "$FILE" | cut -d '/' -f 1 | tr '\n' ',' | sed 's/,$//')
echo $PORTS | xclip -selection clipboard

# Count the total number of open ports
TOTAL_PORTS=$(echo "$PORTS" | tr ',' '\n' | wc -l)


# Print the results with colors
echo -e "${CYAN}Open Ports:${NC} ${GREEN}$PORTS${NC}"
echo -e "${CYAN}Total Ports:${NC} ${YELLOW}$TOTAL_PORTS${NC}"

# Copy ports to clipboard
echo "$PORTS" | xclip -selection clipboard
echo -e "${GREEN}Ports have been copied to clipboard.${NC}"
```

Y guardar con la combinación de teclas: `ctrl+s` & `ctrl+x`

## Pasos para instalar desde `.zshrc` (Kali):
Generalmente todas la nuevas versiones de Kali Linux, y incluyen la Shell ZSH:

![](https://github.com/IsuiLugo/extractP0rts/blob/main/Pasted%20image%2020240718153957.png?raw=true)

Si estás utilizando `zsh`, el procedimiento es muy similar al de `bash`, pero con algunos pequeños ajustes. Aquí te dejo los pasos para que puedas ejecutar tu script desde cualquier ruta:

1. **Mover el script a un directorio incluido en tu `$PATH`:**

   Los directorios en tu `$PATH` son aquellos donde el sistema busca los ejecutables. Un buen lugar para guardar tus scripts personales es el directorio `~/bin`. Si no tienes este directorio, puedes crearlo:

   ```sh
   mkdir -p ~/bin
   ```

2. **Mover el script al directorio `~/bin`:**

   Mueve tu script `extractPorts.sh` al directorio `~/bin`:

   ```sh
   mv extractPorts.sh ~/bin/
   ```

3. **Agregar `~/bin` a tu `$PATH` (si no está ya):**

   Abre tu archivo de configuración de `zsh` (usualmente `.zshrc`) y agrega la siguiente línea:

   ```sh
   export PATH="$HOME/bin:$PATH"
   ```

   Puedes editar el archivo `.zshrc` con tu editor de texto preferido, por ejemplo:

   ```sh
   nano ~/.zshrc
   ```

4. **Recargar el archivo de configuración de `zsh`:**

   Después de agregar la línea a tu `.zshrc`, recarga el archivo de configuración para que los cambios surtan efecto:

   ```sh
   source ~/.zshrc
   ```

5. **Hacer el script ejecutable (si no lo está ya):**

   Asegúrate de que el script sea ejecutable:

   ```sh
   chmod +x ~/bin/extractPorts.sh
   ```

6. **Renombrar el script para facilitar su uso:**

   Opcionalmente, puedes renombrar el script a algo más corto, por ejemplo, `extractPorts`:

   ```sh
   mv ~/bin/extractPorts.sh ~/bin/extractPorts
   ```

### Usar el script desde cualquier lugar

Ahora deberías poder ejecutar tu script desde cualquier lugar simplemente escribiendo `extractPorts` en la terminal seguido del nombre del archivo de salida de Nmap:

```sh
extractPorts <nmap_output_file>
```

Para referencia, aquí está el script completo `extractPorts.sh` (o `extractPorts`):

Ahora deberías poder ejecutar `extractPorts` desde cualquier directorio y obtener los puertos abiertos, el total de puertos, el posible sistema operativo, y copiar los puertos abiertos al portapapeles.

![](https://github.com/IsuiLugo/extractP0rts/blob/main/Pasted%20image%2020240718155021.png?raw=true)

```python
┌──(isui㉿kali)-[~/TryHackMe/Blue]
└─$ extractPorts.sh generalPorts
Open Ports: 135,139,445,3389,49152,49153,49154,49158,49159
Total Ports: 9
Ports have been copied to clipboard.
         
┌──(isui㉿kali)-[~/TryHackMe/Blue]
└─$ 
```

## Pasos para instalar desde `.bashrc` (Parrot u otros):

Para poder ejecutar tu archivo desde cualquier ruta, puedes hacer lo siguiente:

1. **Mover el script a un directorio incluido en tu `$PATH`:**
   
   Los directorios en tu `$PATH` son aquellos donde el sistema busca los ejecutables. Un buen lugar para guardar tus scripts personales es el directorio `~/bin` (en tu directorio home). Si no tienes este directorio, puedes crearlo.

   ```sh
   mkdir -p ~/bin
   ```

2. **Agregar el script al directorio `~/bin`:**

   Mueve tu script `extractPorts.sh` al directorio `~/bin`.

   ```sh
   mv extractPorts.sh ~/bin/
   ```

3. **Agregar `~/bin` a tu `$PATH` (si no está ya):**

   Abre tu archivo de configuración de shell (por ejemplo, `.bashrc` o `.bash_profile` o `.zshrc` dependiendo de tu shell) y agrega la siguiente línea:

   ```sh
   export PATH="$HOME/bin:$PATH"
   ```

   Luego, recarga tu archivo de configuración de shell con:

   ```sh
   source ~/.bashrc  # o ~/.bash_profile o ~/.zshrc
   ```

4. **Hacer el script ejecutable (si no lo está ya):**

   ```sh
   chmod +x ~/bin/extractPorts.sh
   ```

5. **Renombrar el script para facilitar su uso:**

   Opcionalmente, puedes renombrar el script a algo más corto, por ejemplo, `extractPorts`.

   ```sh
   mv ~/bin/extractPorts.sh ~/bin/extractPorts
   ```

### Usar el script desde cualquier lugar

Ahora deberías poder ejecutar tu script desde cualquier lugar simplemente escribiendo `extractPorts` en la terminal seguido del nombre del archivo de salida de Nmap.

```sh
extractPorts <nmap_output_file>
```


With Love Isui! <3  & Happy H4cki1ng!


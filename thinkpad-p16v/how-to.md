### Passo a passo para instalação do debian no thinkpad p16v

Seguindo estes passos conseguimos rodar uma instação sem travamentos,
e utilizando a placa de vídeo da nvidia.

Sugerimos a leitura de todo o documento antes de começar o processo.

#### Passo 1: baixar a iso

Baixar a [imagem do debian 12.9.0](https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/debian-live-12.9.0-amd64-standard.iso).

Verificar que a iso foi baixada corretamente. Rode o comando abaixo e verifique se existe um match entre o ouput do comando e o hash abaixo:

Comando:

```
sha512sum debian-live-12.9.0-amd64-standard.iso
```

Hash a comparar:

```
b5c6e5e108c104793b98893344ccaa4ca7b6714b2fb20a0800df936450a94e246890504d7c183b4a9bc8d5ad5ca1f5c078f9e753fa8408783cb4e7cc9b67b11c
```

#### Passo 2: detectar o flash drive

Gravar a imagem em um *flash drive*.

> Importante! A operação abaixo precisa ser executada no flash-drive.
Caso seja feita no device incorreto todos os dados podem ser perdidos.
Uma maneira simples de identificar o flash-drive é rodar o comando `lsblk` antes de inserir
o flash-drive, inserir, e rodar novamente.

##### Antes de inserir

```
$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
nvme0n1     259:0    0 476.9G  0 disk
├─nvme0n1p1 259:1    0   512M  0 part /boot/efi
├─nvme0n1p2 259:2    0    16G  0 part [SWAP]
└─nvme0n1p3 259:3    0 460.4G  0 part /
```

##### Depois de inserir

```
$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda           8:0    1  28.9G  0 disk
├─sda1        8:1    1   1.4G  0 part
└─sda2        8:2    1   4.7M  0 part
nvme0n1     259:0    0 476.9G  0 disk
├─nvme0n1p1 259:1    0   512M  0 part /boot/efi
├─nvme0n1p2 259:2    0    16G  0 part [SWAP]
└─nvme0n1p3 259:3    0 460.4G  0 part /
```

Como o `sda` apareceu depois de inserir o flash-drive definimos que é nele que vamos gravar a iso.

#### Passo 3: validar o flash-drive

> Importante! O flash-drive precisa estar acessível, mas não montado.

##### Incorreto

```
$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda           8:0    1  28.9G  0 disk
└─sda1        8:1    1   1.4G  0 part /media/best/d-live 12.9.0 st amd64
```

##### Correto

```
$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda           8:0    1  28.9G  0 disk
└─sda1        8:1    1   1.4G  0 part
```

Certifique-se de que não existem mountpoints ativos para o device onde gravará a iso.

#### Passo 3: gravar a iso

Gravaremos agora a iso no flash-drive. Subtitua `sdx` pelo device detectado acima.
No exemplo seria `sda` (não confundir com `sda1`, que é uma partição de `sda`.

```
sudo dd if=debian-live-12.9.0-amd64-standard.iso bs=4M of=/dev/sdx
```

Após finalizada a gravação podemos fazer o boot com o flash-drive.

#### Passo 4: fazer boot com a nova iso e baixar os scripts

- Ao reiniciar o computador, aperte F12 para escolher uma opção de boot.

- Escolher a opção do drive usb.

- Esperar a inicialização do sistema.

- Como a placa de rede wifi não é reconhecida automaticamente no debian será necessário obter conexão com a internet de outra maneira. Sugestões:
    - Utilizar um cabo de rede;
    - Fazer tethering via usb.

- Acesse o sistema como superusuário:

```
sudo su
```

- Após o sistema ter iniciado, verificar conexão com a internet. Algo como `ping 8.8.4.4` deve resolver:

Sucesso de conexão:

```
$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=54 time=42.2 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=54 time=41.3 ms
```

Erro de conexão

```
$ ping 8.8.8.8
ping: connect: Network is unreachable
```

- Importante: não siga para os próximos passos se não tiver conexão com a internet.

- Com a conexão à internet estabelecida instalaremos o git para fazer o download dos scripts:

```
apt install -y git
```

- Agora clonamos o repositório

```
git clone https://github.com/petlove/dev-machine-setup.git
```

#### Passo 5: validar device onde será feita a instalação

Atenção: Os próximos passos irão formatar sua máquina, portanto sejam muito cuidadosos.

Atenção: O script assume que o sistema será instalado no device `nvme0n1`. Caso o device seja diferente o processo todo deverá ser abortado.

Sucesso ao encontrar o device:

```
lsblk  | grep nvme0n1
nvme0n1     259:0    0 476.9G  0 disk
├─nvme0n1p1 259:1    0   512M  0 part /boot/efi
├─nvme0n1p2 259:2    0    16G  0 part [SWAP]
└─nvme0n1p3 259:3    0 460.4G  0 part /
```

As instruções acima indicam que existe a o device `nvme0n1` com aproximadamente 500G. A instalação será feita nele.

Atenção: Caso a saída acima esteja diferente aborte o processo.

#### Passo 5: instalar o sistema base

Agora formataremos e instalaremos o sistema base.

Acesse o diretório contendo os script de instalação:

```
cd dev-machine-setup/
```

Execute o comando abaixo, lembrando que ele formatará sua máquina:

```
./01-bootstrap-live.sh
```

O que é feito pelo script:

1. Instalação de pacotes necessários para o processo de formatação e criação de partições:
2. Deleção de todas as partições existentes
3. Criação de 3 novas partições:
    - Uma onde serão armazenados os arquivos para o boot, com512M
    - Uma de swap, com 16GB
    - Uma para a instalação do sistema, que aproveita o restante do disco
4. Montagem e configuração das partições
5. Instalação do sistema base
6. Cópia de arquivo que será utilizado após o `chroot` para `/mnt/tmp`
6. Acesso chroot

#### Passo 6: acessar chroot e instalar demais dependências

Após a finalização dos comandos acima executamos o `chroot /mnt bin/bash`.

Com isso a partir de agora todos os comandos executados já serão executados no novo sistema.

Execute o comando abaixo que solicitará algumas informações e depois instalará todo o sistema.

```
cd /tmp
./02-bootstrap-chroot.sh
```

- Informe a senha de root para a nova instalação;

- Informe o nome de usuário que será utilizado;

- Informe a senha para o novo usuário;

- Informe o hostname;

- Valide as informações. Caso estejam corretas confirme com `y`.

- Pode ser que o processo solicite mais algumas informações. Basta seguir os steps na tela.

#### Passo 7: reiniciar o computador

- Após a finalização do script reinicie o computador normalmente. Ele deve estar com todo o hardware configurado e funcionando.

- Para acessar a internet da linha de comando podem ser utilizadas 2 alternativas:

```
# Abre uma janela para configuração
nmtui
```

ou

```
# Estabelecer a conexão direta, substituindo:
network-name: sua rede
network-password: sua senha

nmcli device wifi connect network-name password network-password
```

- Agora você pode instalar seu *desktop environment* de preferência, algo como:

```
sudo apt install -y xfce4 xfce4-goodies
```

#### Passo 7: configurar o google chrome

Recomendamos mudar uma flag no google chrome para deixar a execução de vídeos melhor.

1. Acesse o google chrome
2. Digite `chrome://flags/`
3. Habilite a opção "Override software rendering list"

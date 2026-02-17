# md5sum in powershell
You will probably never have to need this, but sometimes you have lots of data on a windows shared disk and you want to verify them upon download. The `bash` cannot find this path, thus you gotta use powershell. That's when this script comes in handy. You give a path and a `md5` file and it will recursively find and match the hashes given an algorithm. Similar to the linux `md5sum` but then in windows powershell.

# Usage
> [!NOTE] 
> Test data is available to try it out.

print help message
```powershell
./md5sum.ps1 -h
```

Run with test data
```powershell
./md5sum.ps1 -c test/data.md5
```

## available options
Other hash algorithms besides `MD5` are also supported
```
USAGE:
    .\md5sum.ps1 [-c, -ChecksumFile] [-a, -Algorithm] [-r, -SearchRoot] [-q, -Quiet] [-h]

EXAMPLES:
    .\md5sum.ps1                           # Default: data.md5, MD5, current dir
    .\md5sum.ps1 -ChecksumFile data.md5 -SearchRoot C:\Downloads
    .\md5sum.ps1 -Quiet                    # Minimal output

PARAMETERS:
    -c, -ChecksumFile    Path to checksum file (default: data.md5) [REQUIRED]
    -a, -Algorithm       MD5|SHA1|SHA256|SHA512 (default: MD5)
    -r, -SearchRoot      Where to recursively search (default: '.')
    -q, -Quiet           Suppress debug output (only `OK/FAILED`)
    -h, -Help            Show this help
```
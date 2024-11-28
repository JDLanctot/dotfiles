function Merge-Hashtables {
    param(
        [hashtable]$Default,
        [hashtable]$Custom
    )
    
    $result = @{}
    
    # Copy all default values
    $Default.Keys | ForEach-Object {
        $result[$_] = $Default[$_]
    }
    
    # Override/merge with custom values
    $Custom.Keys | ForEach-Object {
        $key = $_
        if ($Default.ContainsKey($key) -and $Default[$key] -is [hashtable] -and $Custom[$key] -is [hashtable]) {
            $result[$key] = Merge-Hashtables $Default[$key] $Custom[$key]
        }
        else {
            $result[$key] = $Custom[$key]
        }
    }
    
    return $result
}
﻿#
# Module manifest for module 'TMTools-Prelim'
#

@{

# Script module or binary module file associated with this manifest.
RootModule = '.\TMTools-Prelim.psm1'

# Version number of this module.
ModuleVersion = '1.0.0.0'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = '40473af4-d0c7-4c95-9e55-71c530c8ab4c'

# Author of this module
Author = 'User'

# Company or vendor of this module
CompanyName = 'Unknown'

# Copyright statement for this module
Copyright = '(c) 2020 User. All rights reserved.'

# Description of the functionality provided by this module
# Description = ''

# Minimum version of the Windows PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Get-TMComputerStatus'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = '*'

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = '*'

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        # ProjectUri = ''

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

   =   @ ( )  
  
 #   M o d u l e s   t o   i m p o r t   a s   n e s t e d   m o d u l e s   o f   t h e   m o d u l e   s p e c i f i e d   i n   R o o t M o d u l e / M o d u l e T o P r o c e s s  
 #   N e s t e d M o d u l e s   =   @ ( )  
  
 #   F u n c t i o n s   t o   e x p o r t   f r o m   t h i s   m o d u l e ,   f o r   b e s t   p e r f o r m a n c e ,   d o   n o t   u s e   w i l d c a r d s   a n d   d o   n o t   d e l e t e   t h e   e n t r y ,   u s e   a n   e m p t y   a r r a y   i f   t h e r e   a r e   n o   f u n c t i o n s   t o   e x p o r t .  
 F u n c t i o n s T o E x p o r t   =   ' G e t - T M C o m p u t e r S t a t u s '  
  
 #   C m d l e t s   t o   e x p o r t   f r o m   t h i s   m o d u l e ,   f o r   b e s t   p e r f o r m a n c e ,   d o   n o t   u s e   w i l d c a r d s   a n d   d o   n o t   d e l e t e   t h e   e n t r y ,   u s e   a n   e m p t y   a r r a y   i f   t h e r e   a r e   n o   c m d l e t s   t o   e x p o r t .  
 C m d l e t s T o E x p o r t   =   ' * '  
  
 #   V a r i a b l e s   t o   e x p o r t   f r o m   t h i s   m o d u l e  
 V a r i a b l e s T o E x p o r t   =   ' * '  
  
 #   A l i a s e s   t o   e x p o r t   f r o m   t h i s   m o d u l e ,   f o r   b e s t   p e r f o r m a n c e ,   d o   n o t   u s e   w i l d c a r d s   a n d   d o   n o t   d e l e t e   t h e   e n t r y ,   u s e   a n   e m p t y   a r r a y   i f   t h e r e   a r e   n o   a l i a s e s   t o   e x p o r t .  
 A l i a s e s T o E x p o r t   =   ' * '  
  
 #   D S C   r e s o u r c e s   t o   e x p o r t   f r o m   t h i s   m o d u l e  
 #   D s c R e s o u r c e s T o E x p o r t   =   @ ( )  
  
 #   L i s t   o f   a l l   m o d u l e s   p a c k a g e d   w i t h   t h i s   m o d u l e  
 #   M o d u l e L i s t   =   @ ( )  
  
 #   L i s t   o f   a l l   f i l e s   p a c k a g e d   w i t h   t h i s   m o d u l e  
 #   F i l e L i s t   =   @ ( )  
  
 #   P r i v a t e   d a t a   t o   p a s s   t o   t h e   m o d u l e   s p e c i f i e d   i n   R o o t M o d u l e / M o d u l e T o P r o c e s s .   T h i s   m a y   a l s o   c o n t a i n   a   P S D a t a   h a s h t a b l e   w i t h   a d d i t i o n a l   m o d u l e   m e t a d a t a   u s e d   b y   P o w e r S h e l l .  
 P r i v a t e D a t a   =   @ {  
  
         P S D a t a   =   @ {  
  
                 #   T a g s   a p p l i e d   t o   t h i s   m o d u l e .   T h e s e   h e l p   w i t h   m o d u l e   d i s c o v e r y   i n   o n l i n e   g a l l e r i e s .  
                 #   T a g s   =   @ ( )  
  
                 #   A   U R L   t o   t h e   l i c e n s e   f o r   t h i s   m o d u l e .  
                 #   L i c e n s e U r i   =   ' '  
  
                 #   A   U R L   t o   t h e   m a i n   w e b s i t e   f o r   t h i s   p r o j e c t .  
                 #   P r o j e c t U r i   =   ' '  
  
                 #   A   U R L   t o   a n   i c o n   r e p r e s e n t i n g   t h i s   m o d u l e .  
                 #   I c o n U r i   =   ' '  
  
                 #   R e l e a s e N o t e s   o f   t h i s   m o d u l e  
                 #   R e l e a s e N o t e s   =   ' '  
  
         }   #   E n d   o f   P S D a t a   h a s h t a b l e  
  
 }   #   E n d   o f   P r i v a t e D a t a   h a s h t a b l e  
  
 #   H e l p I n f o   U R I   o f   t h i s   m o d u l e  
 #   H e l p I n f o U R I   =   ' '  
  
 #   D e f a u l t   p r e f i x   f o r   c o m m a n d s   e x p o r t e d   f r o m   t h i s   m o d u l e .   O v e r r i d e   t h e   d e f a u l t   p r e f i x   u s i n g   I m p o r t - M o d u l e   - P r e f i x .  
 #   D e f a u l t C o m m a n d P r e f i x   =   ' '  
  
 }  
  
 
﻿#Requires -version 5.1

<#
SYNTAX
    New-PSSessionConfigurationFile [-Path] <String> [-AliasDefinitions <IDictionary[]>] 
    [-AssembliesToLoad <String[]>] [-Author <String>] [-CompanyName <String>] [-Copyright <String>] 
    [-Description <String>] [-EnvironmentVariables <IDictionary>] [-ExecutionPolicy {Unrestricted | 
    RemoteSigned | AllSigned | Restricted | Default | Bypass | Undefined}] [-FormatsToProcess 
    <String[]>] [-Full] [-FunctionDefinitions <IDictionary[]>] [-GroupManagedServiceAccount <String>] 
    [-Guid <Guid>] [-LanguageMode {FullLanguage | RestrictedLanguage | NoLanguage | 
    ConstrainedLanguage}] [-ModulesToImport <Object[]>] [-MountUserDrive] [-PowerShellVersion 
    <Version>] [-RequiredGroups <IDictionary>] [-RoleDefinitions <IDictionary>] [-RunAsVirtualAccount] 
    [-RunAsVirtualAccountGroups <String[]>] [-SchemaVersion <Version>] [-ScriptsToProcess <String[]>] 
    [-SessionType {Empty | RestrictedRemoteServer | Default}] [-TranscriptDirectory <String>] 
    [-TypesToProcess <String[]>] [-UserDriveMaximumSize <Int64>] [-VariableDefinitions <Object>] 
    [-VisibleAliases <String[]>] [-VisibleCmdlets <Object[]>] [-VisibleExternalCommands <String[]>] 
    [-VisibleFunctions <Object[]>] [-VisibleProviders <String[]>] [<CommonParameters>]
#>

#The name of the role capability should be the name of the role capability file, 
#without the .psrc extension.
$roles = @{
  "company\JEA_ShareAdmins" = @{RoleCapabilities = 'ShareAdmins'}
}

#create the file
$params = @{
 Path = ".\ShareAdmin.pssc"
 SessionType = "RestrictedRemoteServer"
 RunAsVirtualAccount = $True
 RoleDefinitions = $roles
 Description = "JEA Share Admin endpoint"

}
New-PSSessionConfigurationFile @params

#validate it
Test-PSSessionConfigurationFile .\ShareAdmin.pssci n g [ ] > ]    
         [ - S e s s i o n T y p e   { E m p t y   |   R e s t r i c t e d R e m o t e S e r v e r   |   D e f a u l t } ]   [ - T r a n s c r i p t D i r e c t o r y   < S t r i n g > ]    
         [ - T y p e s T o P r o c e s s   < S t r i n g [ ] > ]   [ - U s e r D r i v e M a x i m u m S i z e   < I n t 6 4 > ]   [ - V a r i a b l e D e f i n i t i o n s   < O b j e c t > ]    
         [ - V i s i b l e A l i a s e s   < S t r i n g [ ] > ]   [ - V i s i b l e C m d l e t s   < O b j e c t [ ] > ]   [ - V i s i b l e E x t e r n a l C o m m a n d s   < S t r i n g [ ] > ]    
         [ - V i s i b l e F u n c t i o n s   < O b j e c t [ ] > ]   [ - V i s i b l e P r o v i d e r s   < S t r i n g [ ] > ]   [ < C o m m o n P a r a m e t e r s > ]  
 # >  
  
 # T h e   n a m e   o f   t h e   r o l e   c a p a b i l i t y   s h o u l d   b e   t h e   n a m e   o f   t h e   r o l e   c a p a b i l i t y   f i l e ,    
 # w i t h o u t   t h e   . p s r c   e x t e n s i o n .  
 $ r o l e s   =   @ {  
     " c o m p a n y \ J E A _ S h a r e A d m i n s "   =   @ { R o l e C a p a b i l i t i e s   =   ' S h a r e A d m i n s ' }  
 }  
  
 # c r e a t e   t h e   f i l e  
 $ p a r a m s   =   @ {  
   P a t h   =   " . \ S h a r e A d m i n . p s s c "  
   S e s s i o n T y p e   =   " R e s t r i c t e d R e m o t e S e r v e r "  
   R u n A s V i r t u a l A c c o u n t   =   $ T r u e  
   R o l e D e f i n i t i o n s   =   $ r o l e s  
   D e s c r i p t i o n   =   " J E A   S h a r e   A d m i n   e n d p o i n t "  
  
 }  
 N e w - P S S e s s i o n C o n f i g u r a t i o n F i l e   @ p a r a m s  
  
 # v a l i d a t e   i t  
 T e s t - P S S e s s i o n C o n f i g u r a t i o n F i l e   . \ S h a r e A d m i n . p s s c 
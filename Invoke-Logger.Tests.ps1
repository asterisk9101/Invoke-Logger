$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Invoke-Logger" {
    Context "��{�I�ȋ@�\" {
        It "Information ���x���̃��b�Z�[�W���o�͂����" {
            Invoke-Logger -Info "Message" | Should -Match "Message"
        }
        It "Warning ���x���̃��b�Z�[�W���o�͂����" {
            Invoke-Logger -Warn "Message" | Should -Match "Message"
        }
        It "Error ���x���̃��b�Z�[�W���o�͂����" {
            Invoke-Logger -Err "Message" | Should -Match "Message"
        }
        It "Source ���w��ł���" {
            Invoke-Logger -Info "Message" -Source "Logger" | Should -Match "Logger"
        }
        It "logger �G�C���A�X���g����" {
            logger -Info "Message" | Should -Match "Message"
        }
    }
}
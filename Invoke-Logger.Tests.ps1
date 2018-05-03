$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Invoke-Logger" {
    Context "��{�I�ȋ@�\" {
        It "Information ���x���̃��b�Z�[�W���o�͂����" {
            Invoke-Logger -Info "Message" | Should -Match "Info"
        }
        It "Warning ���x���̃��b�Z�[�W���o�͂����" {
            Invoke-Logger -Warn "Message" | Should -Match "Warn"
        }
        It "Error ���x���̃��b�Z�[�W���o�͂����" {
            Invoke-Logger -Err "Message" | Should -Match "Error"
        }
        It "Source �̊���l�̃X�N���v�g�����o�͂����" {
            Invoke-Logger -Info "Message" | Should -Match "Invoke-Logger.Tests.ps1"
        }
        It "Source ���w��ł���" {
            Invoke-Logger -Info "Message" -Source "Logger" | Should -Match "Logger"
        }
        It "logger �G�C���A�X���g����" {
            logger -Info "Message" | Should -Match "Message"
        }
        It "�p�C�v���C�����͂��ł���" {
            Write-Output "Message" | logger -Info | Should -Match "Message"
        }
        It "�����̓��͂�1�s�ɏW�񂵂ďo�͂���" {
            $Messages = Write-Output "Message1", "Message2`r`nMessage3" | logger -info
            $Messages | % { $_ -split '[\r\n]' } | Measure-Object | Select-Object -ExpandProperty count | Should -Be 1
        }
    }
    Context "�G���[����" {
        It "���x�����w�肳��Ă��Ȃ��ꍇ�̓G���[�ɂȂ�" {
            { logger "hoge" } | Should -Throw
        }
    }
}
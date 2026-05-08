package com.agt.viagens.domain.model;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class StatusViagemTest {

    @Test
    void agendadaPodeTransicionarParaEmAndamentoECancelada() {
        assertThat(StatusViagem.AGENDADA.podeTransicionarPara(StatusViagem.EM_ANDAMENTO)).isTrue();
        assertThat(StatusViagem.AGENDADA.podeTransicionarPara(StatusViagem.CANCELADA)).isTrue();
    }

    @Test
    void agendadaNaoPodeTransicionarParaConcluida() {
        assertThat(StatusViagem.AGENDADA.podeTransicionarPara(StatusViagem.CONCLUIDA)).isFalse();
    }

    @Test
    void emAndamentoPodeTransicionarParaConcluidaECancelada() {
        assertThat(StatusViagem.EM_ANDAMENTO.podeTransicionarPara(StatusViagem.CONCLUIDA)).isTrue();
        assertThat(StatusViagem.EM_ANDAMENTO.podeTransicionarPara(StatusViagem.CANCELADA)).isTrue();
    }

    @Test
    void emAndamentoNaoPodeTransicionarParaAgendada() {
        assertThat(StatusViagem.EM_ANDAMENTO.podeTransicionarPara(StatusViagem.AGENDADA)).isFalse();
    }

    @Test
    void concluidaNaoPodeTransicionarParaNenhumStatus() {
        assertThat(StatusViagem.CONCLUIDA.podeTransicionarPara(StatusViagem.AGENDADA)).isFalse();
        assertThat(StatusViagem.CONCLUIDA.podeTransicionarPara(StatusViagem.EM_ANDAMENTO)).isFalse();
        assertThat(StatusViagem.CONCLUIDA.podeTransicionarPara(StatusViagem.CONCLUIDA)).isFalse();
        assertThat(StatusViagem.CONCLUIDA.podeTransicionarPara(StatusViagem.CANCELADA)).isFalse();
    }

    @Test
    void canceladaNaoPodeTransicionarParaNenhumStatus() {
        assertThat(StatusViagem.CANCELADA.podeTransicionarPara(StatusViagem.AGENDADA)).isFalse();
        assertThat(StatusViagem.CANCELADA.podeTransicionarPara(StatusViagem.EM_ANDAMENTO)).isFalse();
        assertThat(StatusViagem.CANCELADA.podeTransicionarPara(StatusViagem.CONCLUIDA)).isFalse();
        assertThat(StatusViagem.CANCELADA.podeTransicionarPara(StatusViagem.CANCELADA)).isFalse();
    }
}

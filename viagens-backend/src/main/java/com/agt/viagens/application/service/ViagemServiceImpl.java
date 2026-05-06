package com.agt.viagens.application.service;

import com.agt.viagens.application.dto.request.AtualizarStatusRequest;
import com.agt.viagens.application.dto.request.CriarViagemRequest;
import com.agt.viagens.application.dto.response.ViagemResponse;
import com.agt.viagens.application.mapper.ViagemMapper;
import com.agt.viagens.domain.exception.TransicaoStatusInvalidaException;
import com.agt.viagens.domain.exception.ViagemNaoEncontradaException;
import com.agt.viagens.domain.model.StatusViagem;
import com.agt.viagens.domain.model.Usuario;
import com.agt.viagens.domain.model.Viagem;
import com.agt.viagens.domain.port.ViagemPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ViagemServiceImpl implements ViagemService {

    private final ViagemPort   viagemPort;
    private final ViagemMapper viagemMapper;

    @Override
    @Transactional(readOnly = true)
    public List<ViagemResponse> listarPorUsuario(Usuario usuario) {
        return viagemPort.buscarPorUsuario(usuario).stream()
                .map(viagemMapper::toResponse)
                .toList();
    }

    @Override
    @Transactional
    public ViagemResponse criar(CriarViagemRequest request, Usuario usuario) {
        Viagem viagem = Viagem.builder()
                .destino(request.destino())
                .dataIda(request.dataIda())
                .dataVolta(request.dataVolta())
                .finalidade(request.finalidade())
                .transporte(request.transporte())
                .observacoes(request.observacoes())
                .status(StatusViagem.AGENDADA)
                .usuario(usuario)
                .build();

        return viagemMapper.toResponse(viagemPort.salvar(viagem));
    }

    @Override
    @Transactional
    public ViagemResponse atualizarStatus(Long id, AtualizarStatusRequest request, Usuario usuario) {
        Viagem viagem = viagemPort.buscarPorIdEUsuario(id, usuario)
                .orElseThrow(() -> new ViagemNaoEncontradaException(id));

        StatusViagem statusAtual = viagem.getStatus();
        StatusViagem novoStatus = request.status();

        if (!statusAtual.podeTransicionarPara(novoStatus)) {
            throw new TransicaoStatusInvalidaException(statusAtual, novoStatus);
        }

        viagem.setStatus(novoStatus);
        return viagemMapper.toResponse(viagemPort.salvar(viagem));
    }
}

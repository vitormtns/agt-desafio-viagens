package com.agt.viagens.application.service;

import com.agt.viagens.application.dto.request.AtualizarStatusRequest;
import com.agt.viagens.application.dto.request.CriarViagemRequest;
import com.agt.viagens.application.dto.response.ViagemResponse;
import com.agt.viagens.application.mapper.ViagemMapper;
import com.agt.viagens.domain.model.Usuario;
import com.agt.viagens.domain.port.ViagemPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * ============================================================
 *  CANDIDATO — implemente os três métodos abaixo.
 *
 *  Recursos disponíveis:
 *    - viagemPort   → acesso ao banco de dados (ver ViagemPort)
 *    - viagemMapper → converte Viagem → ViagemResponse
 *
 *  Dicas:
 *    - Exceções de domínio: domain/exception/
 *    - Regra de transição: StatusViagem.podeTransicionarPara()
 *    - Entidade Viagem: domain/model/Viagem.java (use o Builder)
 *    - Use @Transactional nos métodos que escrevem no banco
 * ============================================================
 */
@Service
@RequiredArgsConstructor
public class ViagemServiceImpl implements ViagemService {

    private final ViagemPort   viagemPort;
    private final ViagemMapper viagemMapper;

    @Override
    @Transactional(readOnly = true)
    public List<ViagemResponse> listarPorUsuario(Usuario usuario) {
        // TODO: buscar viagens do usuário via viagemPort e converter cada uma com viagemMapper.toResponse()
        throw new UnsupportedOperationException("Não implementado.");
    }

    @Override
    @Transactional
    public ViagemResponse criar(CriarViagemRequest request, Usuario usuario) {
        // TODO: construir entidade Viagem a partir do request, associar ao usuario, salvar via viagemPort e retornar mapeada
        throw new UnsupportedOperationException("Não implementado.");
    }

    @Override
    @Transactional
    public ViagemResponse atualizarStatus(Long id, AtualizarStatusRequest request, Usuario usuario) {
        // TODO 1: buscar viagem por id e usuario — lançar ViagemNaoEncontradaException se não encontrar
        // TODO 2: validar transição com viagem.getStatus().podeTransicionarPara(request.status())
        //         lançar TransicaoStatusInvalidaException se inválida
        // TODO 3: atualizar o status, salvar via viagemPort e retornar mapeada
        throw new UnsupportedOperationException("Não implementado.");
    }
}

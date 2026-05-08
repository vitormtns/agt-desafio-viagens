package com.agt.viagens.domain.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneOffset;

@Entity
@Table(
    name = "viagens",
    indexes = {
        @Index(name = "idx_viagem_usuario_criado", columnList = "usuario_id, criado_em DESC")
    }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Viagem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    private String destino;

    @Column(name = "data_ida", nullable = false)
    private LocalDate dataIda;

    @Column(name = "data_volta", nullable = false)
    private LocalDate dataVolta;

    @Column(nullable = false, length = 100)
    private String finalidade;

    @Column(nullable = false, length = 100)
    private String transporte;

    @Column(length = 1000)
    private String observacoes;

    @Builder.Default
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private StatusViagem status = StatusViagem.AGENDADA;

    @Column(name = "criado_em", nullable = false, updatable = false)
    private LocalDateTime criadoEm;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @PrePersist
    void prePersist() {
        if (this.criadoEm == null) this.criadoEm = LocalDateTime.now(ZoneOffset.UTC);
    }
}

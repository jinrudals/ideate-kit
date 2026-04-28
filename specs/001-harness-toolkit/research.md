# Research: Harness Toolkit

## R-001: AI-Specific Prompt Deployment Patterns

**Decision**: speckit의 `update-agent-context.sh` 패턴을 재사용. agent type별 파일 경로 매핑 + 포맷 변환.

**Rationale**: speckit이 이미 25+ AI agent를 지원하는 검증된 매핑 테이블을 보유. 동일 패턴을 사용하면 유저가 speckit과 harness를 같은 프로젝트에 설치할 때 일관된 경험 제공.

**Alternatives considered**:
- 각 AI별 별도 패키지 배포 → 유지보수 비용 과다, 거부
- 단일 AGENTS.md에 모든 prompt 통합 → AI별 native 경험 손실, 거부

## R-002: Memory File Format

**Decision**: Markdown with structured headings + placeholder tokens (`[TOKEN_NAME]`). speckit의 constitution/spec 템플릿과 동일한 패턴.

**Rationale**: AI agent가 가장 잘 파싱하는 포맷이 markdown. placeholder 패턴은 speckit에서 검증됨. 별도 파서 불필요.

**Alternatives considered**:
- YAML/JSON structured data → AI agent가 자연어 컨텍스트로 읽기 어려움, 거부
- 자유형 markdown (no template) → agent 간 계약 불명확, 거부

## R-003: Phase Prerequisite Validation

**Decision**: 각 prompt 내에서 필수 memory file 존재 여부를 체크하는 inline validation. speckit의 `check-prerequisites.sh` 패턴 참고하되, harness용 별도 스크립트 `check-phase.sh` 작성.

**Rationale**: bash 스크립트로 파일 존재 확인 → JSON 출력 → prompt가 파싱. speckit과 동일한 UX 패턴.

**Alternatives considered**:
- prompt 내에서 직접 파일 체크 (스크립트 없이) → AI마다 파일 접근 방식 다름, 스크립트가 더 안정적
- 모든 phase를 단일 prompt로 → phase별 독립성 상실, 거부

## R-004: Handoff → speckit 연동 방식

**Decision**: `harness.handoff`가 각 서비스별로 speckit의 spec-template.md 포맷과 호환되는 `spec.md`를 생성. 유저가 해당 서비스 디렉토리에서 `speckit.specify`를 실행하면 기존 spec.md를 입력으로 인식.

**Rationale**: speckit.specify는 이미 기존 spec 파일이 있으면 그것을 기반으로 동작하는 패턴을 지원. harness가 speckit 포맷으로 생성하면 추가 변환 불필요.

**Alternatives considered**:
- harness가 speckit을 직접 호출 → speckit 의존성 발생, FR-012 위반
- 별도 변환 스크립트 → 불필요한 중간 단계, 거부

## R-005: Installer (`harness init`) 구현 방식

**Decision**: 단일 bash 스크립트 `init.sh`가 `--ai <type>` 인자를 받아 실행. `src/` 내용을 `.harness/`로 복사 + `install-prompts.sh`로 AI별 prompt 배포.

**Rationale**: speckit과 동일한 설치 UX. bash만으로 동작하므로 추가 런타임 불필요.

**Alternatives considered**:
- npm/pip 패키지 → 언어 런타임 의존성 발생, 거부
- Makefile → 유저 친화적이지 않음, 거부

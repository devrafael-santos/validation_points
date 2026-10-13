backend_epic = Epic.find_or_create_by!(jira_key: "SALES-EPIC-1") do |epic|
  epic.name = "Sales Backend"
  epic.project_type = :backend
  epic.description = "API e serviços de vendas"
end

frontend_epic = Epic.find_or_create_by!(jira_key: "SALES-EPIC-2") do |epic|
  epic.name = "Sales Frontend"
  epic.project_type = :frontend
  epic.description = "Interface web do checkout e painel"
end

mobile_epic = Epic.find_or_create_by!(jira_key: "SALES-EPIC-3") do |epic|
  epic.name = "App Mobile Vendas"
  epic.project_type = :mobile
  epic.description = "Aplicativo iOS e Android"
end

tasks_data = [
  {
    epic: backend_epic,
    jira_key: "SALES-101",
    title: "Implementar validação de cupons expirados na finalização de compra",
    jira_url: "https://jira.exemplo.com/browse/SALES-101",
    pull_request_url: "https://github.com/avantsoft/sales_backend/pull/42",
    stage: :internal_review,
    priority: :urgent,
    story_points: 3,
    description: "Requer atenção especial na concorrência de estoque e expiração de cashback."
  },
  {
    epic: backend_epic,
    jira_key: "SALES-102",
    title: "Refatorar endpoint de cálculo de frete para transportadoras terceiras",
    jira_url: "https://jira.exemplo.com/browse/SALES-102",
    pull_request_url: "https://github.com/avantsoft/sales_backend/pull/45",
    stage: :internal_review,
    priority: :high,
    story_points: 5,
    description: "Adicionado cache no Redis e fallback em caso de timeout da API externa."
  },
  {
    epic: frontend_epic,
    jira_key: "SALES-201",
    title: "Ajustar máscara de cartão de crédito e feedback de erro de pagamento",
    jira_url: "https://jira.exemplo.com/browse/SALES-201",
    pull_request_url: "https://github.com/avantsoft/sales_frontend/pull/88",
    stage: :internal_review,
    priority: :medium,
    story_points: 2,
    description: "Componente React/Stimulus atualizado com validação de Luhn."
  },
  {
    epic: mobile_epic,
    jira_key: "SALES-301",
    title: "Corrigir crash ao tentar compartilhar comprovante em PDF no iOS",
    jira_url: "https://jira.exemplo.com/browse/SALES-301",
    pull_request_url: "https://github.com/avantsoft/sales_mobile/pull/19",
    stage: :internal_review,
    priority: :urgent,
    story_points: 1,
    description: "Permissão de salvar arquivo em cache corrigida para iOS 17+."
  },
  {
    epic: backend_epic,
    jira_key: "SALES-105",
    title: "Configurar webhook para recebimento de status Pix",
    jira_url: "https://jira.exemplo.com/browse/SALES-105",
    pull_request_url: nil,
    stage: :in_progress,
    priority: :low,
    story_points: 2,
    description: "Ainda desenvolvendo os testes unitários."
  }
]

tasks_data.each do |data|
  Task.find_or_create_by!(jira_key: data[:jira_key]) do |task|
    task.assign_attributes(data)
  end
end

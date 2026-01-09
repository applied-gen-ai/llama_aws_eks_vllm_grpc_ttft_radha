{{/*
Application name
*/}}
{{- define "llm-app.name" -}}
llm
{{- end }}

{{/*
Deployment name
*/}}
{{- define "llm-app.deploymentName" -}}
llm-deployment
{{- end }}

{{/*
HPA name
*/}}
{{- define "llm-app.hpaName" -}}
llm-hpa
{{- end }}

{{/*
Common labels
*/}}
{{- define "llm-app.labels" -}}
app: {{ include "llm-app.name" . }}
app.kubernetes.io/name: {{ include "llm-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "llm-app.selectorLabels" -}}
app: {{ include "llm-app.name" . }}
{{- end }}

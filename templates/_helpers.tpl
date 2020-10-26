{{/*
Expand the name of the chart.
*/}}
{{- define "gogs.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gogs.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "gogs.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "gogs.labels" -}}
helm.sh/chart: {{ include "gogs.chart" . }}
{{ include "gogs.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "gogs.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gogs.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "gogs.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "gogs.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return Gogs volume capacity
*/}}
{{- define "gogs.volume.capacity" -}}
{{- if .Values.global.gogs.volumeCapacity }}
    {{- .Values.global.gogs.volumeCapacity -}}
{{- else -}}
  {{- default "1Gi" | quote }}
{{- end -}}
{{- end -}}

{{/*
Return Gogs volume storageClass
*/}}
{{- define "gogs.volume.storageClass" -}}
{{- if .Values.global.gogs.volumeStorageClass }}
    {{- .Values.global.gogs.volumeStorageClass -}}
{{- end -}}
{{- end -}}


{{/*
Postgresql references
*/}}
{{/*
Return PostgreSQL password
*/}}
{{- define "postgresql.password" -}}
{{- if .Values.global.postgresql.postgresqlPassword }}
    {{- .Values.global.postgresql.postgresqlPassword -}}
{{- else if .Values.postgresqlPassword -}}
    {{- .Values.postgresqlPassword -}}
{{- else -}}
    {{- randAlphaNum 10 -}}
{{- end -}}
{{- end -}}

{{/*
Return PostgreSQL database name
*/}}
{{- define "postgresql.database" -}}
{{- if .Values.global.postgresql.database }}
    {{- .Values.global.postgresql.database -}}
{{- else if .Values.postgresqlDatabase -}}
    {{- .Values.postgresqlDatabase -}}
{{- else -}}
    {{ default "sampledb" }}
{{- end -}}
{{- end -}}

{{/*
Return PostgreSQL username
*/}}
{{- define "postgresql.username" -}}
{{- if .Values.global.postgresql.postgresqlUsername }}
    {{- .Values.global.postgresql.postgresqlUsername -}}
{{- else if .Values.postgresqlUsername -}}
    {{- .Values.postgresqlUsername -}}
{{- else -}}
    {{- randAlphaNum 10 -}}
{{- end -}}
{{- end -}}

{{/*
Verify tls or not
*/}}
{{- define "gogs.skipTlsVerify" -}}
{{- if .Values.skipTlsVerify -}}
    {{- .Values.skipTlsVerify -}}
{{- else -}}
    true
{{- end -}}
{{- end -}}

{{/*
Install lock
*/}}
{{- define "gogs.installLock" -}}
{{- if .Values.installLock -}}
    {{- .Values.installLock -}}
{{- else -}}
    true
{{- end -}}
{{- end -}}


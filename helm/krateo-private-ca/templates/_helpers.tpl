{{- define "krateo-private-ca.labels" -}}
app.kubernetes.io/name: krateo-private-ca
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{- end -}}

{{- /* The layout every object here depends on; refuse to render anything else. */ -}}
{{- define "krateo-private-ca.checkLayout" -}}
{{- if ne .Values.trustNamespace .Release.Namespace -}}
{{- fail (printf "trustNamespace (%s) must equal the release namespace (%s): trust-manager reads the CA Secret from its trust namespace, and the ClusterIssuer reads it from cert-manager's cluster resource namespace, so all three must be the same namespace" .Values.trustNamespace .Release.Namespace) -}}
{{- end -}}
{{- range .Values.issuance -}}
{{- if or (not .name) (not .namespaces) (not .dnsNames) -}}
{{- fail "every issuance entry needs a name, at least one namespace and at least one dnsName" -}}
{{- end -}}
{{- end -}}
{{- end -}}

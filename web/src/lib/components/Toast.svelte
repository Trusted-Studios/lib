<!-- Sollte bitte nich verwendet werden, dass ist eine absolute Katastrophe und es ist mit Sicherheit nicht gut!-->
<script lang="ts">
    import { Wait } from "$lib/scripts/Wait";
    import { useNuiEvent } from "$utils/NuiEvents";
    import { Toast } from "flowbite-svelte";
    import { CheckCircleSolid, CloseCircleSolid, ExclamationCircleSolid } from "flowbite-svelte-icons";

    let toasts: any = [];

    const NotificationType: any = {
        "success": "green",
        "warning": "orange",
        "error": "red",
    }

    async function showToast(message: string, type: string, duration: number) {
        const newToast = { message, type, open: true};        
        toasts = [...toasts, newToast];
        setTimeout(async () => {
            toasts[0].open = false
            await Wait(500);
            toasts = toasts.filter((t: any) => t !== newToast);
        }, duration);
    }

    useNuiEvent('trigger:toast', function(data: any){
        showToast(data?.message || "invalid", data?.type, data?.duration)
    })

</script>

<div class="custom">
    {#each toasts as toast, index (toast.message + index)}
        <Toast color={NotificationType[toast.type]} bind:open={toast.open} position="top-right" style={`top: ${index > 0 ? 74 * index + 10 : 10}px`}>
            <svelte:fragment slot="icon">
                {#if toast.type === 'success'}
                    <CheckCircleSolid class="w-5 h-5" />
                    <span class="sr-only">Check icon</span>
                {:else if toast.type === 'warning'}
                    <CloseCircleSolid class="w-5 h-5" />
                    <span class="sr-only">Error icon</span>
                {:else if toast.type === 'error'}
                    <ExclamationCircleSolid class="w-5 h-5" />
                    <span class="sr-only">Warning icon</span>
                {/if}
            </svelte:fragment>
            {toast.message}
        </Toast>
    {/each}
</div>
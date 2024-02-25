<script lang="ts">
    import { Button, Modal } from "flowbite-svelte";
    import { ExclamationCircleOutline } from "flowbite-svelte-icons";
    import { useNuiEvent } from "../utils/NuiEvents";
    import { fetchNui } from "../utils/FetchNui";

    let open: boolean = false;
    let description: string = "This is a warning, would you like to continue?";
    let accept: string = "Accept";
    let decline: string = "Decline";
    let other: any;

    useNuiEvent('open:warning', function(data: any){
        open = true;
        description = data?.description || description
        accept = data?.accept || accept
        decline = data?.decline || decline
        other = data?.other
    })

    function handleChoice(accepted: boolean) {
        fetchNui('handle:warning', {
            accepted: accepted,
            other: other
        })

        open = false;
    }
</script>

<Modal bind:open size="xs" autoclose dismissable={false}>
    <div class="text-center">
        <ExclamationCircleOutline class="mx-auto mb-4 text-gray-400 w-12 h-12 dark:text-gray-200" />
        <h3 class="mb-5 text-lg font-normal text-gray-500 dark:text-gray-400">{description}</h3>
        <Button color="red" class="me-2" on:click={() => handleChoice(true)}>{accept}</Button>
        <Button color="alternative" on:click={() => handleChoice(false)}>{decline}</Button>
    </div>
</Modal>
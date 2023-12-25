<script lang="ts">
    import { Button, Label, Modal, Range } from "flowbite-svelte";

    export let open: boolean = false;
    export let description: string;
    export let confirm: string;
    export let rangeLabel: string;
    export let range: {min: number, max: number};
    export let onConfirm: Function;
    export let onClose: Function;

    let minmaxValue: number = 0;

    function handleClick(action: string) {
        if (action === "accepted") {
            onConfirm();
        }
    }

    $: if (open === false) {
        onClose();
    }
</script>

<Modal bind:open size="xs">
    <p class="text-base leading-relaxed text-gray-500 dark:text-gray-400">{description}</p>
    <Label>{rangeLabel}</Label>
    <Range id="range-minmax" min="{range.min}" max="{range.max}" bind:value={minmaxValue} />
    <p>Value: {minmaxValue}</p>
    <svelte:fragment slot="footer">
        <Button class="me-2" on:click={() => handleClick("accepted")}>{confirm}</Button>
    </svelte:fragment>
</Modal>
